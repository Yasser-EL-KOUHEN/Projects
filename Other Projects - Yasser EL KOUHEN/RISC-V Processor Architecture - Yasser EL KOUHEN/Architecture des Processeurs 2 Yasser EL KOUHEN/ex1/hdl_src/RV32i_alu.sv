//                              -*- Mode: Verilog -*-
// Filename        : RV32i_alu.sv
// Description     : Arithmetic & Logic Unit
// Author          : michel agoyan
// Created On      : Thu Jul 18 13:23:15 2024
// Last Modified By: michel agoyan
// Last Modified On: Thu Jul 18 13:23:15 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

module alu (

    input [3:0] func_i,
    input signed [31:0] op1_i,
    input signed [31:0] op2_i,
    output signed [31:0] d_o,
    output zero_o,
    output lt_o
);

  logic [31:0] d_w;

  always_comb begin

    case (func_i)
      1:  d_w = op1_i + op2_i;  //ADD
      2:  d_w = op1_i - op2_i;  //SUB
      3:  d_w = op1_i & op2_i;  //AND
      4:  d_w = op1_i ^ op2_i;  //XOR
      5:  d_w = op1_i | op2_i;  //OR
      6:  d_w = {31'b0, op1_i < op2_i};  //SLT   
      7:  d_w = {31'b0, $unsigned(op1_i) < $unsigned(op2_i)};  //SLTU
      8:  d_w = op1_i << op2_i[4:0];  //SLL
      9:  d_w = op1_i >> op2_i[4:0];  //SRL
      10: d_w = op1_i >>> op2_i[4:0];  //SRA
      11: d_w = op1_i;  // copy RS1
      12: d_w = 32'hxxxxxxxx;

      default: d_w = 32'h0;

    endcase  // case (func_i)
  end
  assign zero_o = (d_w == 32'h0) ? 1'b1 : 1'b0;
  assign lt_o = ($signed(d_w) < $signed(32'h0)) ? 1'b1 : 1'b0;
  assign d_o = d_w;

endmodule
