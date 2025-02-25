//Testbench de la permutation avec xor
//Yasser EL KOUHEN
//11 mai 2024

`timescale 1ns / 1ps
import ascon_pack ::*;

module permutation_xor_tb
(
	//empty declarative part
);

	type_state state_i_s;
	logic sel_i_s, en_xor_data_i_s, en_xor_key_begin_i_s, en_cypher_begin_i_s, en_xor_lsb_i_s, en_xor_key_end_i_s,resetb_i_s, en_i_s, en_tag_end_i_s;
	logic [127 : 0] key_i_s, tag_o_s;
	logic [63 : 0] data_i_s, cypher_o_s;
	logic [3:0] round_i_s;

	logic clock_i_s=1'b0;

	permutation_xor DUT (
		.state_i(state_i_s),
		.sel_i(sel_i_s),

		.en_xor_data_i(en_xor_data_i_s),
    		.en_xor_key_begin_i(en_xor_key_begin_i_s),
    		.key_i(key_i_s),
    		.data_i(data_i_s),

		.en_cypher_begin_i(en_cypher_begin_i_s),
    		.cypher_o(cypher_o_s),   

		.round_i(round_i_s),

		.en_xor_lsb_i(en_xor_lsb_i_s), 
    		.en_xor_key_end_i(en_xor_key_end_i_s),

		.clock_i(clock_i_s),
 		.resetb_i(resetb_i_s),
 		.en_i(en_i_s),

		.en_tag_end_i(en_tag_end_i_s), 
		.tag_o(tag_o_s)
	);
always begin 
        #25;
        assign clock_i_s = ~clock_i_s;
    end

initial begin
	//initialisation des signaux
	resetb_i_s=1'b0;
	sel_i_s=1'b0; // sélecteur du mux
	
	en_i_s = 1'b1; // Active l'écriture de state_s dans le registre
        en_cypher_begin_i_s = 1'b0;
        en_tag_end_i_s = 1'b0;

        round_i_s = 4'b0000;
        key_i_s = 128'h8a55114d1cb6a9a2be263d4d7aecaaff; // K

	en_xor_data_i_s=1'b0;
	en_xor_key_begin_i_s=1'b0;
	en_xor_lsb_i_s=1'b0;
	en_xor_key_end_i_s=1'b0;

	// Appliquer le reset
        #2;
        resetb_i_s = 1'b1;
        
// Valeur initiale : 80400c0600000000 8a55114d1cb6a9a2 be263d4d7aecaaff 4ed0ec0b98c529b7 c8cddf37bcd0284a
	state_i_s[0]=64'h80400c0600000000 ;
	state_i_s[1]=64'h8a55114d1cb6a9a2 ;
	state_i_s[2]=64'hbe263d4d7aecaaff ;
	state_i_s[3]=64'h4ed0ec0b98c529b7 ;
	state_i_s[4]=64'hc8cddf37bcd0284a ;

	#48; // Attendre que le système se stabilise après le reset
        sel_i_s = 1'b1;


	// Phase d'initialisation 

        for (int round = 1; round < 12; round++) begin
            round_i_s = round; 
            @(posedge clock_i_s); // Attendre un cycle d'horloge
        end	
end
endmodule : permutation_xor_tb





