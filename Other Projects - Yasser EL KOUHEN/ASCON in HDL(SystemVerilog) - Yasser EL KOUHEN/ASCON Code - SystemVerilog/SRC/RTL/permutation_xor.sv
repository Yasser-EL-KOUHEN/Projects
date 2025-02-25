//module permutation sans xor
//Yasser EL KOUHEN
//10 mai 2024

import ascon_pack::*;

module permutation_xor 
(
	input type_state state_i,
	input logic sel_i,

	input logic en_xor_data_i,
    	input logic en_xor_key_begin_i,
    	input logic [127 : 0] key_i,
    	input logic [63 : 0] data_i,

	input logic en_cypher_begin_i,
    	output logic [63 : 0] cypher_o,   

	input logic [3:0] round_i,

	input logic en_xor_lsb_i, 
    	input logic en_xor_key_end_i,

	input logic clock_i,
 	input logic resetb_i,
 	input logic en_i,

	input logic en_tag_end_i, 
	output logic [127 : 0] tag_o
);

//fils internes
type_state cst_to_sub_s, sub_to_lin_s;
type_state mux_to_xorb_s,xorb_to_cst_s;
type_state lin_to_xore_s,xore_to_register_s;
type_state state_s;

mux_state mux (
	.sel_i(sel_i),
	.data1_i(state_i), // quand sel_i=0
	.data2_i(state_s), // quand sel_i=1
	.data_o(mux_to_xorb_s)
);

xor_begin_perm xor_begin (
 	.en_xor_data_i(en_xor_data_i),
 	.en_xor_key_i(en_xor_key_begin_i),
	.key_i(key_i),
	.data_i(data_i),
	.state_i(mux_to_xorb_s),
	.state_o(xorb_to_cst_s)
);

register_w_en 
   #(
     .nb_bits_g(64)
     ) reg_begin
   (
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.en_i(en_cypher_begin_i),
	.data_i(xorb_to_cst_s[0]),
 	.data_o(cypher_o)
);

constant_addition pc (
	.state_i(xorb_to_cst_s),
	.round_i(round_i),
	.state_o(cst_to_sub_s)
);

substitution_layer ps (
	.state_i(cst_to_sub_s),
	.state_o(sub_to_lin_s)
);

diffusion_lin pl (
	.state_i(sub_to_lin_s),
	.state_o(lin_to_xore_s)
);

xor_end_perm xor_end (
	.en_xor_lsb_i(en_xor_lsb_i), 
	.en_xor_key_i(en_xor_key_end_i), 
	.key_i(key_i),
	.state_i(lin_to_xore_s),
	.state_o(xore_to_register_s)
);

state_register_w_en state_reg(
	.clock_i(clock_i),
 	.resetb_i(resetb_i),
 	.en_i(en_i),
	.data_i(xore_to_register_s),
 	.data_o(state_s)
);

register_w_en 
   #(
     .nb_bits_g(128)
     ) reg_end
   (
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.en_i(en_tag_end_i),
	.data_i({state_s[3],state_s[4]}),
	.data_o(tag_o)
    ) ;

endmodule : permutation_xor








