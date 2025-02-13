//                              -*- Mode: Verilog -*-
// Filename        : RV32i_top.sv
// Description     : RV32i top
// Author          : ROUCWL7441
// Created On      : Tue Aug 20 08:43:20 2024
// Last Modified By: ROUCWL7441
// Last Modified On: Tue Aug 20 08:43:20 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

module RV32i_top (
    input logic clk_i,
    input logic resetn_i,
    output logic [31:0] imem_add_o,
    input logic [31:0] imem_data_i,
    output logic [31:0] dmem_add_o,
    input logic [31:0] dmem_do_i,
    output logic [31:0] dmem_di_o,
    output logic dmem_we_o,
    output logic dmem_re_o,
    output logic [3:0] dmem_ble_o

);
  logic [31:0] instruction_w;
  logic  stall_w;
  logic [2:0] pc_next_sel_w;
  logic [3:0] alu_control_w;
  logic reg_we_w;
  logic [1:0] alu_src1_w;
  logic alu_src2_w;
  logic [2:0] imm_gen_sel_w;
  logic [1:0] wb_sel_w;

  logic [4:0] rd_add_w;

  logic alu_zero_w;
  logic alu_lt_w;

  RV32i_datapath dp (  /*AUTOINST*/
      // Inputs
      .clk_i(clk_i),
      .resetn_i(resetn_i),
      .stall_i(stall_w),
      .pc_next_sel_i(pc_next_sel_w),
      .alu_control_i(alu_control_w),
      .reg_we_i(reg_we_w),
      .alu_src1_i(alu_src1_w),
      .alu_src2_i(alu_src2_w),
      .imm_gen_sel_i(imm_gen_sel_w),
      .wb_sel_i(wb_sel_w),

      .rd_add_i(rd_add_w),

      .imem_data_i(imem_data_i),
      .dmem_do_i(dmem_do_i),
      // Outputs
      .instruction_o(instruction_w),
      .alu_zero_o(alu_zero_w),
      .alu_lt_o(alu_lt_w),
      .imem_add_o(imem_add_o),
      .dmem_add_o(dmem_add_o),
      .dmem_di_o(dmem_di_o),
      .dmem_ble_o(dmem_ble_o)
  );

  RV32i_controlpath cp (
      .clk_i(clk_i),
      .resetn_i(resetn_i),
      .instruction_i(instruction_w),
      .alu_zero_i(alu_zero_w),
      .alu_lt_i(alu_lt_w),
      .pc_next_sel_o(pc_next_sel_w),
      .reg_we_o(reg_we_w),
      .mem_we_o(dmem_we_o),
      .mem_re_o(dmem_re_o),
      .alu_src1_o(alu_src1_w),
      .alu_src2_o(alu_src2_w),
      .imm_gen_sel_o(imm_gen_sel_w),
      .alu_control_o(alu_control_w),
      .wb_sel_o(wb_sel_w),

      .rd_add_o(rd_add_w),

      .stall_o(stall_w)
  );

endmodule
