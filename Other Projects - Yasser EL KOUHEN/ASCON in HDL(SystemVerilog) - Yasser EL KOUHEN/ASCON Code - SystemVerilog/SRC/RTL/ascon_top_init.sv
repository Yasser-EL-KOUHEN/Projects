// ASCON_top_init
// Yasser EL KOUHEN
// 12 mai 2024


import ascon_pack::*;

module ASCON_top_init (
    	input logic clock_i, resetb_i,
    	input logic start_i,
   	output logic end_o
);

    // Signaux d'interconnexion
    	logic [3:0] round_s;
    	logic en_cpt_perm_s, init_p6_s, init_p12_s;
    	logic input_mode_s, en_reg_state_s, xor_key_s;
    	type_state state_input_s, state_output_s;

	assign state_input_s[0] = 64'h80400c0600000000;
	assign state_input_s[1] = 64'h8a55114d1cb6a9a2;
	assign state_input_s[2] = 64'hbe263d4d7aecaaff;
	assign state_input_s[3] = 64'h4ed0ec0b98c529b7;
	assign state_input_s[4] = 64'hc8cddf37bcd0284a;

    // Inst_FSM
    	FSM_init FSM_inst (
        	.clock_i(clock_i), 
        	.resetb_i(resetb_i),
        	.start_i(start_i),
        	.round_i(round_s),
        	.en_cpt_perm_o(en_cpt_perm_s), 
        	.init_p6_o(init_p6_s), 
        	.init_p12_o(init_p12_s),
        	.input_mode_o(input_mode_s), 
        	.en_reg_state_o(en_reg_state_s), 
        	.xor_key_o(xor_key_s),
        	.end_o(end_o)
    	);

    // Initialisation du compteur double
    	compteur_double_init compteur_double_init (
        	.clock_i(clock_i),
        	.resetb_i(resetb_i),
        	.cpt_o(round_s),
        	.en_i(en_cpt_perm_s),
        	.init_a_i(init_p12_s),
        	.init_b_i(init_p6_s)
    	);

    	permutation ASCON_step1 (

        	.state_i(state_input_s),
        	.data_sel_i(input_mode_s),
        	.round_i(round_s),
        	.clock_i(clock_i),
        	.resetb_i(resetb_i),
        	.en_reg_state_i(en_reg_state_s),
        	.state_o(state_output_s)

    	);

endmodule : ASCON_top_init
