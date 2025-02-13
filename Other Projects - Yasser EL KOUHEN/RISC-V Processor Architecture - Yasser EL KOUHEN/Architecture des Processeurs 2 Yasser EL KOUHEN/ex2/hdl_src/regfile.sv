//                              -*- Mode: Verilog -*-
// Filename        : regfile.sv
// Description     : risc-v_ap registers file
// Author          : michel agoyan
// Created On      : Thu Jul 18 11:39:25 2024
// Last Modified By: michel agoyan
// Last Modified On: Thu Jul 18 11:39:25 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

module regfile (
    input logic clk_i,



    input logic we_i,
    input logic [4:0] rd_add_i,
    input logic [4:0] rs1_add_i,
    input logic [4:0] rs2_add_i,
    input logic [31:0] rd_data_i,
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o
);

  // 32 registers of 32-bit width, R0 is hardwired  to 0

  logic [31:0] register_r[0:31]='{default:0};




  // Read ports for rs1 and rs2, always 0 for R0
  assign rs1_data_o = (rs1_add_i != 5'b0)? register_r[rs1_add_i] :0;
  assign rs2_data_o = (rs2_add_i != 5'b0)? register_r[rs2_add_i] :0;
  
  // Write port for rd
  always_ff @(posedge clk_i) begin





    if (we_i) begin
      //R0 is not writable
      if (rd_add_i != 5'b0) register_r[rd_add_i] <= rd_data_i;
    end
  end

endmodule
