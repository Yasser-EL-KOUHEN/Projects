//                              -*- Mode: Verilog -*-
// Filename        : mux_state.sv
// Description     : package definition
// Author          : Jean-Baptiste RIGAUD
// Created On      : Sat Oct 14 15:30:30 2023
// Last Modified By: Jean-Baptiste RIGAUD
// Last Modified On: Sat Oct 14 15:30:30 2023
// Update Count    : 0
// Status          : Unknown, Use with caution!
`timescale 1 ns/ 1 ps

module mux_state import ascon_pack::*; 
   (
    input logic sel_i,
    input 	type_state data1_i,
    input 	type_state data2_i,
    output 	type_state data_o
    );

   assign data_o = (sel_i == 1'b0) ? data1_i : data2_i;

endmodule : mux_state
   
