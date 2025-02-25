//                              -*- Mode: Verilog -*-
// Filename        : xor_end_perm.sv
// Description     : package definition
// Author          : Jean-Baptiste RIGAUD
// Created On      : Sat Oct 14 15:30:30 2023
// Last Modified By: Jean-Baptiste RIGAUD
// Last Modified On: Sat Oct 14 15:30:30 2023
// Update Count    : 0
// Status          : Unknown, Use with caution!
`timescale 1 ns/ 1 ps

module xor_end_perm import ascon_pack::*; 
   (
    input logic en_xor_lsb_i, //active xor avec LSB en fin de DA
    input logic en_xor_key_i, //active xor avec cle en fin initialisation
    input logic [127 : 0] key_i,
    input 	type_state state_i,
    output 	type_state state_o
    );

   logic [127 : 0] key_add_s;
   logic [63 : 0] x3_s;
   logic [63 : 0] x4_s;

   //trois premiers mots inchangés
   assign state_o[0] = state_i[0];
   assign state_o[1] = state_i[1];
   assign state_o[2] = state_i[2];

   //valeurs temporaires
   assign x3_s = state_i[3];
   //traitement du 1 en phase de donnees associées
   assign x4_s[63:1] = state_i[4][63:1];
   assign x4_s[0] = state_i[4][0] ^ en_xor_lsb_i;
   //xor avec la clé d'entrée en fin d'initialisation
   assign key_add_s = (en_xor_key_i == 1'b1) ? {x3_s, x4_s}^key_i:{x3_s, x4_s};
  //finalisation de l'état de sortie 
   assign state_o[3]= key_add_s[127:64];
   assign state_o[4]= key_add_s[63:0];
   
endmodule : xor_end_perm
   
