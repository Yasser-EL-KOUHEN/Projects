/**
 * File              : wsync_mem_o128.sv
 * Author            : Raphaël COMPS <r.comps@emse.fr>
 * Date              : 05.12.2024
 * Last Modified Date: 05.12.2024
 * Last Modified By  : Raphaël COMPS <r.comps@emse.fr>
 */
//                              -*- Mode: Verilog -*-
// Filename        : wsync_mem.sv
// Description     : SRAM model. Synchonous writing, Asynchronous reading
// Author          : michel agoyan
// Created On      : Sun Aug 18 17:29:59 2024
// Last Modified By: michel agoyan
// Last Modified On: Sun Aug 18 17:29:59 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

module wsync_mem_o128 #(
    parameter SIZE = 4096,
    parameter LATENCY = 5,
    INIT_FILE = ""
) (
    input logic clk_i,
    input logic we_i,
    input logic re_i,
    input logic [3:0] ble_i,
    input logic [31:0] d_i,
    input logic [$clog2(SIZE)-1:0] add_i,
    output logic valid_o,
    output logic [3:0][31:0] d_o
);
  logic [31:0] mem[SIZE];
  logic [31:0] mask_w;
  logic [31:0] mem_masked_w,data_masked_w, data_w;

  assign mask_w = {{8{ble_i[3]}}, {8{ble_i[2]}}, {8{ble_i[1]}}, {8{ble_i[0]}}};


  // fake latency counter
  int unsigned counter_n, counter_q;

  initial begin
    if (INIT_FILE == "") $readmemh("../firmware/zero.hex", mem);
    else $readmemh(INIT_FILE, mem);
  end

  assign mem_masked_w = mem[add_i] & ~mask_w;
  assign data_masked_w = d_i & mask_w ;
  assign data_w= mem_masked_w | data_masked_w;

  always_ff @(posedge clk_i) begin : wmem
    //if (we_i == 1'b1) mem[add_i] <= (d_i & mask_w )| (mem[add_i] & ~mask_w);
    if (we_i == 1'b1) mem[add_i] <= data_w;
  end

  always_comb begin : rmem
    if (re_i == 1'b1) begin
      if (counter_q == LATENCY) begin
        valid_o = 1'b1;
        d_o = {{mem[add_i+3] & mask_w},{mem[add_i+2] & mask_w},{mem[add_i+1] & mask_w},{mem[add_i] & mask_w}} ;
        counter_n = 0;
      end else begin
        valid_o = 1'b0;
        d_o = 0;
        counter_n = counter_q + 1;
      end
    end else begin
        valid_o = 1'b0;
        d_o = 0;
        counter_n = 0;
    end
  end

  always_ff @(posedge clk_i) counter_q <= counter_n;

endmodule
