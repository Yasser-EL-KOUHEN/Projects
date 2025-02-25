// Module : FSM complète
// Yasser EL KOUHEN
// 12 mai 2024

module FSM (
	input logic clock_i, resetb_i,
	input logic start_i,
	input logic [3:0] round_i,
	input logic [2:0] blocs_i,
	input logic data_valid_i,	

	output logic en_cpt_perm_o, init_p6_o, init_p12_o,
	output logic input_mode_o, en_reg_state_o, en_tag_o, en_cipher_o,
	output logic en_xor_key_b_o, en_xor_data_b_o, en_xor_key_e_o, en_xor_lsb_e_o,
	output logic en_cpt_block_o, init_block_o,
	output logic end_o
);

// declaration d'un nouveau type de variable qui sont les valeurs entre crochets
typedef enum {attente, conf_init, init_rd0, init_rd0_to_rd10, init_rd11, conf_da, da_rd0, da_rd0_to_rd5, da_rd6, conf_tc, tc_rd0, tc_rd0_to_rd6, conf_finalisation, finalisation_rd0, finalisation_rd0_to_rd10, finalisation_rd11, fin} state_t;

// internal variable to model the FSM
state_t current_state, next_state;


// si le front d'horloge ou reset est a l'état 0
always_ff @(posedge clock_i or negedge resetb_i)
	begin : seq_0
		// si le reset est a l'état 0
		if (resetb_i==1'b0)
			current_state <= attente;
		else current_state <= next_state;
	end :seq_0

// first combinational process for transitions
always_comb 
	begin : comb_0
		case (current_state)
			attente:
				if (start_i==1'b1) 
					next_state = conf_init;
				else next_state = attente;
			
			conf_init:
				if (data_valid_i==1'b1) 
					next_state = init_rd0;
				else next_state = conf_init;
			init_rd0:
				next_state = init_rd0_to_rd10;
			init_rd0_to_rd10:
				if (round_i == 10) 
					next_state = init_rd11;
				else next_state =init_rd0_to_rd10;
			init_rd11:
				next_state = conf_da;

			conf_da:
					next_state = da_rd0;
			da_rd0: 
				if (data_valid_i==1'b1) 
					next_state = da_rd0_to_rd5;
				else next_state = da_rd0;
			da_rd0_to_rd5:
				if (round_i == 10) 
					next_state = da_rd6;
				else next_state =da_rd0_to_rd5;
			da_rd6: 
				next_state = conf_tc;

			conf_tc: 
				next_state = tc_rd0;
			tc_rd0:
				if (data_valid_i==1'b1) 
					next_state = tc_rd0_to_rd6;
				else next_state = tc_rd0;		
			tc_rd0_to_rd6:
				if (round_i == 11) //peut-être problème sur le round_i
					if (blocs_i == 2)
						next_state = conf_finalisation ;
					else next_state = conf_tc; 
				else next_state =tc_rd0_to_rd6;
			
			conf_finalisation:
				next_state = finalisation_rd0;
			finalisation_rd0:
				if (data_valid_i==1'b1) 
					next_state = finalisation_rd0_to_rd10;
				else next_state = finalisation_rd0;
			finalisation_rd0_to_rd10:
				if (round_i == 10) 
					next_state = finalisation_rd11; 
				else next_state =finalisation_rd0_to_rd10;
			finalisation_rd11:
				next_state = fin;
			fin:
				next_state = attente;
			
			default:next_state = attente;
		endcase	
	end :comb_0

// second combinational process for outputs
always_comb 
	begin : comb_1
		en_cpt_perm_o =0;
		init_p6_o = 0; 
		init_p12_o = 0;
		input_mode_o = 0;
		en_reg_state_o = 0;
		en_tag_o = 0;
		en_cipher_o = 0;
		en_xor_key_b_o = 0;
		en_xor_data_b_o = 0;
		en_xor_key_e_o = 0;
		en_xor_lsb_e_o = 0;

		en_cpt_block_o = 0;
		init_block_o = 0;
		end_o = 0;
		case (current_state)

			conf_init: begin
				en_cpt_perm_o = 1;
				init_p12_o = 1;
			end
			init_rd0: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
			end
			init_rd0_to_rd10: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
			end
			init_rd11: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_xor_key_e_o = 1;
			end

			conf_da: begin
				en_cpt_perm_o = 1;
				input_mode_o = 1;
				init_p6_o = 1;
				input_mode_o = 1;
			end
			da_rd0: begin
				en_xor_data_b_o = 1;
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
			end
			da_rd0_to_rd5: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
			end
			da_rd6: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_xor_lsb_e_o = 1;
				init_block_o = 1; //
			end

			conf_tc: begin
				en_cpt_perm_o = 1;
				init_p6_o = 1;
				en_cpt_block_o = 1;
				input_mode_o = 1;
				//init_block_o = 1;
			end
			tc_rd0: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				//en_cpt_block_o = 1;
				en_xor_data_b_o = 1;
				en_cipher_o = 1;
				//input_mode_o = 1;	
			end
			tc_rd0_to_rd6: begin
				en_cpt_perm_o = 1;
				//en_cpt_block_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
			end
	
			conf_finalisation: begin
				en_cpt_perm_o = 1;
				init_p12_o = 1;
				input_mode_o = 1;
			end
			finalisation_rd0: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				en_xor_key_b_o = 1;
				en_xor_data_b_o = 1;
				en_cipher_o = 1;
			end
			finalisation_rd0_to_rd10: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
			end
			finalisation_rd11: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_xor_key_e_o = 1;
				en_tag_o = 1;
			end

			fin : begin
				end_o = 1;
			end
		
		endcase
	end :comb_1 

endmodule : FSM
