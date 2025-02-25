//                              -*- Mode: Verilog -*-
// Filename        : compteur_simple_init.sv
// Description     : package definition
// Author          : Jean-Baptiste RIGAUD
// Created On      : Sat Oct 14 15:30:30 2023
// Last Modified By: Jean-Baptiste RIGAUD
// Last Modified On: Sat Oct 14 15:30:30 2023
// Update Count    : 0
// Status          : Unknown, Use with caution!
`timescale 1 ns/ 1 ps

module compteur_simple_init import ascon_pack::*;
   (
    input logic 	clock_i,
    input logic 	resetb_i,
    input logic 	en_i,
    input logic 	init_a_i,
    output logic [2 : 0] data_o      
    ) ;

   logic [2:0] cpt_s;
   
   always_ff @(posedge clock_i or negedge resetb_i)
     begin
	if (resetb_i == 1'b0) begin
	   cpt_s <= 0;
	end
	else begin 
	   if (en_i == 1'b1) 
	     begin
		if (init_a_i==1'b1) begin
		   cpt_s<=0;
		end 
		else cpt_s <= cpt_s+1;
	     end
	end
     end

   assign data_o = cpt_s;
   
endmodule: compteur_simple_init


