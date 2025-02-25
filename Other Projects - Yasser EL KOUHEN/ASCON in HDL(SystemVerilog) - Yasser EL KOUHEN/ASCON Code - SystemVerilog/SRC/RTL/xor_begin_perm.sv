//                              -*- Mode: Verilog -*-
// Filename        : xor_begin_perm.sv
// Description     : package definition
// Author          : Jean-Baptiste RIGAUD
// Created On      : Sat Oct 14 15:30:30 2023
// Last Modified By: Jean-Baptiste RIGAUD
// Last Modified On: Sat Oct 14 15:30:30 2023
// Update Count    : 0
// Status          : Unknown, Use with caution!
`timescale 1 ns/ 1 ps

module xor_begin_perm import ascon_pack::*; 
   (
    input logic en_xor_data_i, //active xor donnée associée ou plaintext
    input logic en_xor_key_i, //active xor avec cle pour la finalisation
    input logic [127 : 0] key_i,
    input logic [63 : 0] data_i,
    input 	type_state state_i,
    output 	type_state state_o
    );

   logic [127 : 0] key_add_s;
   logic [63 : 0] x1_s;
   logic [63 : 0] x2_s;

   //premier mot de l'étét
   assign state_o[0] = (en_xor_data_i == 1'b1) ? state_i[0]^data_i : state_i[0];

   //deuxieme et troisième mot
   assign x1_s = state_i[1];
   assign x2_s = state_i[2];
   assign key_add_s = (en_xor_key_i == 1'b1) ? {x1_s, x2_s}^key_i:{x1_s, x2_s};
   
   assign state_o[1]= key_add_s[127:64];
   assign state_o[2]= key_add_s[63:0];

   //troisieme et quatrieme mots
   assign state_o[3]= state_i[3];
   assign state_o[4]= state_i[4];
    
endmodule : xor_begin_perm
   
