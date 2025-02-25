//                              -*- Mode: Verilog -*-
// Filename        : resister_w_en.sv
// Description     : package definition
// Author          : Jean-Baptiste RIGAUD
// Created On      : Sat Oct 14 15:30:30 2023
// Last Modified By: Jean-Baptiste RIGAUD
// Last Modified On: Sat Oct 14 15:30:30 2023
// Update Count    : 0
// Status          : Unknown, Use with caution!
`timescale 1 ns/ 1 ps

module register_w_en import ascon_pack::*;
   #(
     parameter nb_bits_g=32
     )
   (
    input logic clock_i,
    input logic resetb_i,
    input logic en_i,
    input logic [nb_bits_g-1 : 0] data_i,
    output logic [nb_bits_g-1 : 0] data_o      
    ) ;

   logic [nb_bits_g-1 : 0] 	   data_s;
   
   always_ff @(posedge clock_i or negedge resetb_i)
     begin
	if (resetb_i == 1'b0) begin
	   data_s <= 0;
	end
	else begin 
	   if (en_i == 1'b1) 
	     begin
		data_s <= data_i;
	     end
	   else data_s <= data_s;
	end
     end

   assign data_o = data_s;
   
endmodule: register_w_en


