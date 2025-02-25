// ASCON_top
// Yasser EL KOUHEN
// 12 mai 2024


import ascon_pack::*;

module ascon_top (
    	input logic clock_i, resetb_i,
	input logic [63:0] data_i,
	input logic data_valid_i,  
	input logic [127:0] key_i, nonce_i,
    	input logic start_i,
	output logic [63:0] cipher_o,
	output logic cipher_valid_o,
	output logic [127:0] tag_o,
    	output logic end_o
);

// Signaux d'interconnexion
    	logic [3:0] round_s;
	logic [2:0] blocs_s;
    	logic en_cpt_perm_s, init_p6_s, init_p12_s;
    	logic input_mode_s, en_reg_state_s, en_tag_s, en_cipher_s;
    	type_state state_input_s;
	logic en_xor_key_b_s, en_xor_data_b_s, en_xor_key_e_s, en_xor_lsb_e_s;

	logic en_cpt_block_s, init_block_s;

	assign state_input_s[0] = 64'h80400c0600000000;
	assign state_input_s[1] = 64'h8a55114d1cb6a9a2;
	assign state_input_s[2] = 64'hbe263d4d7aecaaff;
	assign state_input_s[3] = 64'h4ed0ec0b98c529b7;
	assign state_input_s[4] = 64'hc8cddf37bcd0284a;
	
	assign nonce_i = {state_input_s[3],state_input_s[4]};
//Instance FSM
	FSM FSM(
		.clock_i(clock_i), 
		.resetb_i(resetb_i),
		.start_i(start_i),
		.round_i(round_s), 
		.blocs_i(blocs_s), //manque peut être blocs_i dans la FSM
		.data_valid_i(data_valid_i),		
		.en_cpt_perm_o(en_cpt_perm_s), 
		.init_p6_o(init_p6_s), 
		.init_p12_o(init_p12_s),
		.input_mode_o(input_mode_s), 
		.en_reg_state_o(en_reg_state_s), 
		.en_tag_o(en_tag_s),
		.en_cipher_o(en_cipher_s),
		.en_xor_key_b_o(en_xor_key_b_s), 
		.en_xor_data_b_o(en_xor_data_b_s), 
		.en_xor_key_e_o(en_xor_key_e_s), 
		.en_xor_lsb_e_o(en_xor_lsb_e_s),
		.en_cpt_block_o(en_cpt_block_s), //
		.init_block_o(init_block_s), //
		.end_o(end_o)
	);

// Initialisation du compteur double
    	compteur_double_init compteur_rondes (
        	.clock_i(clock_i),
        	.resetb_i(resetb_i),
        	.en_i(en_cpt_perm_s),
        	.init_a_i(init_p12_s),
        	.init_b_i(init_p6_s),
		.data_o(round_s) // data_o = [2:0] et round_s=[3:0]
    	);

// Initialisation du compteur simple
	compteur_simple_init compteur_blocs (
        	.clock_i(clock_i),
        	.resetb_i(resetb_i),
    		.en_i(en_cpt_block_s),
    		.init_a_i(init_block_s),
		.data_o(blocs_s)      
	) ;

	permutation_xor perm(
		.state_i(state_input_s),
		.sel_i(input_mode_s),

		.en_xor_data_i(en_xor_data_b_s),
    		.en_xor_key_begin_i(en_xor_key_b_s),
    		.key_i(key_i),
    		.data_i(data_i),

		.en_cypher_begin_i(en_cipher_s),
    		.cypher_o(cipher_o),   

		.round_i(round_s),

		.en_xor_lsb_i(en_xor_lsb_e_s), 
    		.en_xor_key_end_i(en_xor_key_e_s),

		.clock_i(clock_i),
 		.resetb_i(resetb_i),
 		.en_i(en_reg_state_s),

		.en_tag_end_i(en_tag_s), 
		.tag_o(tag_o)
	);

endmodule : ascon_top



