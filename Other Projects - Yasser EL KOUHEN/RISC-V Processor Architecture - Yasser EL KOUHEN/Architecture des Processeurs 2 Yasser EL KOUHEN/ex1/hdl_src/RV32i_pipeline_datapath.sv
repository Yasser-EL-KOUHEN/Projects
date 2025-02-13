//                              -*- Mode: Verilog -*-
// Filename        : RV32i_monocycle_datapath.sv
// Description     : monocycle datapath
// Author          : michel agoyan
// Created On      : Thu Jul 18 13:52:18 2024
// Last Modified By: michel agoyan
// Last Modified On: Thu Jul 18 13:52:18 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

module RV32i_datapath (
    input logic clk_i,
    input logic resetn_i,
    //from control path
    input logic stall_i,
    input logic [2:0] pc_next_sel_i,
    input logic [3:0] alu_control_i,
    input logic reg_we_i,
    input logic [1:0] alu_src1_i,
    input logic alu_src2_i,
    input logic [2:0] imm_gen_sel_i,
    input logic [1:0] wb_sel_i,

    input logic [4:0] rd_add_i,

    output logic [31:0] instruction_o,
    output logic alu_zero_o,
    output logic alu_lt_o,
    //from and to data and instruction memories
    output logic[31:0]imem_add_o,
    input logic[31:0] imem_data_i,
    output logic[31:0]dmem_add_o,
    input logic[31:0] dmem_do_i,
    output logic[31:0] dmem_di_o,
    output logic [3:0] dmem_ble_o
);
  
  import RV32i_pkg::*;

  //logic [31:0] instruction_w;
  logic [31:0] pc_counter_r, pc_counter_dec_r, pc_next_w, pc_plus4_w;
  logic[31:0] pc_j_target_w,pc_jr_target_w,pc_br_target_w,pc_br_target_r;
  logic [31:0] inst_w;
  logic [ 2:0] func3_w;
  logic [ 4:0] rs1_add_w;
  logic [ 4:0] rs2_add_w;
  logic [ 4:0] rd_add_w;
  logic [6:0] opcode_w,func7_w;

  logic [31:0] rs1_data_w, rs2_data_w;
  logic [31:0] imm_w;

  logic [31:0] wb_data_w;
  logic [31:0] alu_op1_data_w, alu_op2_data_w, alu_do_w;
  logic [3:0] ble_w;
  logic rdu_w;
  logic [31:0] rd_shifter_do_w, wr_shifter_di_w;
  logic [1:0] dmem_add_lsb_w;

  logic [31:0] inst_r,pc_plus4_r;
  logic [4:0] rs1_add_r, rs2_add_r;
  logic [4:0] rd_add_dec_r;
  logic [6:0] opcode_r,func7_dec_r;

  logic [31:0] alu_op1_data_r, alu_op2_data_r, rs2_data_r;
  logic [31:0] dmem_add_r, dmem_di_r, alu_do_r, rd_shifter_do_r;
  logic [3:0] dmem_ble_r;
  logic [2:0] func3_dec_r,func3_exec_r;
  

  assign pc_plus4_w = pc_counter_r + 4;
  assign pc_j_target_w = pc_counter_dec_r + imm_w;
  assign pc_br_target_w = pc_counter_dec_r + imm_w;
  assign pc_jr_target_w = (pc_counter_dec_r + rs1_data_w) & 32'hFFFF_FFFE;

  always_comb begin : pc_next_comb 

    case (pc_next_sel_i)
      SEL_PC_PLUS_4: pc_next_w = pc_plus4_w;
      SEL_PC_JAL: pc_next_w = pc_j_target_w;
      SEL_PC_JALR: pc_next_w = pc_jr_target_w;
      SEL_PC_BRANCH :pc_next_w = pc_br_target_r;
      default: pc_next_w = pc_plus4_w;
    endcase

  end

  

  //Décodage de l'instruction

   always_ff @(posedge clk_i, negedge resetn_i) begin : program_counter
    if (resetn_i == 1'b0) pc_counter_r <= 0;
    else
      begin
        if (stall_i == 1'b0)
          pc_counter_r <= pc_next_w;
      end 
  end

  assign inst_w = imem_data_i;

  assign opcode_w  = inst_w[6:0];
  assign func3_w =inst_w[14:12];
  assign rs1_add_w = inst_w[19:15];
  assign rs2_add_w = inst_w[24:20];
  assign func7_w =inst_w[31:25];
  

  
  always_ff @(posedge clk_i or resetn_i) begin : dec_stage
  if(resetn_i == 1'b0)
    begin
      opcode_r<=0;
      rd_add_dec_r<=0;
      func3_dec_r<=0;
      rs1_add_r<=0;
      rs2_add_r<=0;
      func7_dec_r<=0;
      pc_counter_dec_r <=0;
      pc_plus4_r <=0;
    end
  else
    begin
      if( stall_i == 1'b0)
      begin
        opcode_r<= opcode_w;
        rd_add_dec_r<=inst_w[11:7];
        func3_dec_r<=func3_w;
        rs1_add_r<=rs1_add_w;
        rs2_add_r<=rs2_add_w;
        func7_dec_r<=func7_w;
        pc_counter_dec_r <= pc_counter_r;
        pc_plus4_r <=pc_plus4_w;
      end
    end 
  end
  assign inst_r={func7_dec_r, rs2_add_r,rs1_add_r,func3_dec_r,rd_add_dec_r,opcode_r};
  assign rd_add_w=rd_add_i;
  

  assign instruction_o= inst_r;

  //mux to select ALU op1

  always_comb begin : alu_src1_mux_comb

    case (alu_src1_i)
      SEL_OP1_RS1: alu_op1_data_w = rs1_data_w;
      SEL_OP1_IMM: alu_op1_data_w = imm_w;
      SEL_OP1_PC: alu_op1_data_w = pc_counter_r;
      default: alu_op1_data_w = 0;
    endcase
  end

  //mux to select ALU op2

  always_comb begin : alu_src2_mux_comb

    case (alu_src2_i)
      SEL_OP2_RS2: alu_op2_data_w = rs2_data_w;
      SEL_OP2_IMM: alu_op2_data_w = imm_w;
      default: alu_op2_data_w = 0;
    endcase
  end

  //immediate velue genarator

  always_comb begin : imm_generator

    case (imm_gen_sel_i)
      IMM20_UNSIGN_U: imm_w = {inst_r[31:12], 12'b0};
      IMM12_SIGEXTD_I: imm_w = {{20{inst_r[31]}}, inst_r[31:20]};
      IMM12_SIGEXTD_S:
      imm_w = {{20{inst_r[31]}}, {inst_r[31:25], inst_r[11:7]}};
      IMM12_SIGEXTD_SB:
      imm_w = {
        {20{inst_r[31]}}, inst_r[7], inst_r[30:25], inst_r[11:8], 1'b0
      };
      IMM20_UNSIGN_UJ:
      imm_w = {
        {12{inst_r[31]}}, inst_r[19:12], inst_r[20], inst_r[30:21], 1'b0
      };

      default: imm_w = 0;
    endcase
  end

always @(posedge clk_i or negedge resetn_i) begin : exec_stage
  if (resetn_i == 1'b0)
    begin
      alu_op1_data_r <=0;
      alu_op2_data_r <= 0;
      rs2_data_r <= 0;
      func3_exec_r <=0;
      pc_br_target_r <= 0;

    end
  else
    begin
      alu_op1_data_r <= alu_op1_data_w;
      alu_op2_data_r <= alu_op2_data_w;
      rs2_data_r <= rs2_data_w;
      func3_exec_r <= func3_dec_r;
      pc_br_target_r <= pc_br_target_w;
    end
end

  //byte and word reading accesses
  //non aligned accesses are not managed

  
  assign dmem_add_lsb_w = dmem_add_r[1:0];

  always_comb begin : byte_enable_comb

    case (func3_w[1:0])
      2'b00: begin

        unique case (dmem_add_lsb_w)

          2'b00: ble_w = 4'b0001;
          2'b01: ble_w = 4'b0010;
          2'b10: ble_w = 4'b0100;
          2'b11: ble_w = 4'b1000;
        endcase
      end
      //misaligned halfword accesses are not managed
      2'b01: begin

        unique case (dmem_add_lsb_w)

          2'b00: ble_w = 4'b0011;
          2'b01: ble_w = 4'b0011;
          2'b10: ble_w = 4'b1100;
          2'b11: ble_w = 4'b1100;
        endcase
      end
      2'b10:   ble_w = 4'b1111;
      default: ble_w = 4'b1111;
    endcase

  end

  assign rdu_w = func3_exec_r[2];

  always_comb begin : rd_shifter_comb

    case (ble_w)
      4'b1111: rd_shifter_do_w = dmem_do_i;
      4'b0001: begin
        if (rdu_w == 1'b1) rd_shifter_do_w = {{24{1'b0}}, dmem_do_i[7:0]};
        else rd_shifter_do_w = {{24{dmem_do_i[7]}}, dmem_do_i[7:0]};
      end
      4'b0010: begin
        if (rdu_w == 1'b1) rd_shifter_do_w = {{24{1'b0}}, dmem_do_i[15:8]};
        else rd_shifter_do_w = {{24{dmem_do_i[15]}}, dmem_do_i[15:8]};
      end
      4'b0100: begin
        if (rdu_w == 1'b1) rd_shifter_do_w = {{24{1'b0}}, dmem_do_i[23:16]};
        else rd_shifter_do_w = {{24{dmem_do_i[23]}}, dmem_do_i[23:16]};
      end
      4'b1000: begin
        if (rdu_w == 1'b1) rd_shifter_do_w = {{24{1'b0}}, dmem_do_i[31:24]};
        else rd_shifter_do_w = {{24{dmem_do_i[31]}}, dmem_do_i[31:24]};
      end
      4'b0011: begin
        if (rdu_w == 1'b1) rd_shifter_do_w = {{16{1'b0}}, dmem_do_i[15:0]};
        else rd_shifter_do_w = {{16{dmem_do_i[15]}}, dmem_do_i[15:0]};
      end
      4'b1100: begin
        if (rdu_w == 1'b1) rd_shifter_do_w = {{16{1'b0}}, dmem_do_i[31:16]};
        else rd_shifter_do_w = {{16{dmem_do_i[31]}}, dmem_do_i[31:16]};
      end
      default: rd_shifter_do_w = 32'b0;
    endcase

  end

  

  always_comb begin : wr_shifter_comb
        case (ble_w)
      4'b1111: wr_shifter_di_w = rs2_data_r;
      4'b0001: begin

        wr_shifter_di_w = {24'b0, rs2_data_r[7:0]};
      end
      4'b0010: begin

        wr_shifter_di_w = {16'b0, rs2_data_r[7:0],8'b0};
      end
      4'b0100: begin
        wr_shifter_di_w = {8'b0, rs2_data_r[7:0],16'b0};
      end
      4'b1000: begin
        wr_shifter_di_w = {rs2_data_r[7:0],24'b0};
      end
      4'b0011: begin
        wr_shifter_di_w = {16'b0, rs2_data_r[15:0]};
      end
      4'b1100: begin
        wr_shifter_di_w ={rs2_data_r[15:0],16'b0};
      end
      default: wr_shifter_di_w = 32'b0;
    endcase

  end

 

  alu alu_inst (
      .func_i(alu_control_i),
      .op1_i(alu_op1_data_r),
      .op2_i(alu_op2_data_r),
      .d_o(alu_do_w),
      .zero_o(alu_zero_o),
      .lt_o(alu_lt_o)
  );
  regfile regfile_inst (
      .clk_i(clk_i),

      .we_i(reg_we_i),
      .rd_add_i(rd_add_w),
      .rs1_add_i(rs1_add_r),
      .rs2_add_i(rs2_add_r),
      .rd_data_i(wb_data_w),
      .rs1_data_o(rs1_data_w),
      .rs2_data_o(rs2_data_w)
  );

assign imem_add_o={pc_counter_r[13:2],2'b00};

always @(posedge clk_i, negedge resetn_i) begin:mem_stage
  if(resetn_i == 1'b0)
    begin
      dmem_add_r <= 32'b0;
      dmem_di_r <= 32'b0;
      dmem_ble_r <= 4'b0;
    end
  else
    begin
      dmem_add_r <= alu_do_w;
      dmem_di_r <= wr_shifter_di_w;
      dmem_ble_r <= ble_w;
    end
end

assign dmem_di_o=dmem_di_r;
assign dmem_ble_o=dmem_ble_r;
assign dmem_add_o=dmem_add_r;

//mux to select the value to write back

  always_comb begin : wb_mux

    case (wb_sel_i)
      SEL_WB_ALU: wb_data_w = alu_do_r;
      SEL_WB_MEM: wb_data_w = rd_shifter_do_r;
      SEL_WB_PC_PLUS_4: wb_data_w = pc_plus4_w;
      default: wb_data_w = 0;
    endcase

  end

  
  always @(posedge clk_i, negedge resetn_i) begin:wb_stage
    if(resetn_i == 1'b0)
      begin
        rd_shifter_do_r <= 32'b0;
        alu_do_r <= 32'b0;
      end
    else
      begin
        rd_shifter_do_r <= rd_shifter_do_w;
        alu_do_r <= dmem_add_r;
      end
   
  end
  

 
endmodule  // RV32i_monocycle_datapath
