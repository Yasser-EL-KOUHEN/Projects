//                              -*- Mode: Verilog -*-
// Filename        : RV32i_monocycle_tb.sv
// Description     : RV32i monocycle testbench
// Author          : michel.agoyan
// Created On      : Tue Aug 20 10:56:09 2024
// Last Modified By: michel.agoyan
// Last Modified On: Tue Aug 20 10:56:09 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns / 1ps
module RV32i_tb ();

  logic clk_r;
  logic resetn_r;
 

  real freq = 100;
  real half_period;

  logic [31:0] inst_w;


  RV32i_soc #(
      .IMEM_INIT_FILE("../firmware/imem.hex"),
      .DMEM_INIT_FILE("../firmware/dmem.hex")
  ) RV32i_soc_inst (
      .clk_i(clk_r),
      .resetn_i(resetn_r)
  );

  //clock generator
  always begin
    #(half_period) clk_r = ~clk_r;
  end

  assign inst_w=RV32i_tb.RV32i_soc_inst.RV32i_core.imem_data_i;

  initial begin
    if ($test$plusargs("FREQ")) begin
      if ($value$plusargs("FREQ=%d", freq))
        $display("running frequency is equal to :%d MHz", int'(freq));
    end
    half_period = realtime'($ceil(500.0 / freq));
    $display("half running period= %f", half_period);

    
    $dumpfile("dump.vcd");
    $dumpvars(0, RV32i_soc_inst);
    clk_r = 1'b0;
    resetn_r = 1'b1;
    #1 resetn_r = 1'b0;

    repeat (5) begin
      @(posedge clk_r);
    end

    #0.1 resetn_r = 1'b1;
    @(posedge clk_r);


    wait (inst_w == 32'h0000006F)

    repeat (5) begin
      @(posedge clk_r);
    end

    $display("Simulation stops at %t", $time);

    $stop;
  end

endmodule
