//testbench de la Couche de substitution 
//Yasser EL KOUHEN
//10 mai 2024

import ascon_pack ::*;

`timescale 1ns / 1ps
module substitution_layer_tb
(
	//empty declarative part
);

	type_state state_i_s, state_o_s;

	substitution_layer DUT (
		.state_i(state_i_s),
		.state_o(state_o_s)
	);

// Permutation (r=00) Addition constante : 80400c0600000000 8a55114d1cb6a9a2 be263d4d7aecaa0f 4ed0ec0b98c529b7 c8cddf37bcd0284a

initial begin
	state_i_s[0]=64'h80400c0600000000 ;
	state_i_s[1]=64'h8a55114d1cb6a9a2 ;
	state_i_s[2]=64'hbe263d4d7aecaa0f ;
	state_i_s[3]=64'h4ed0ec0b98c529b7 ;
	state_i_s[4]=64'hc8cddf37bcd0284a ;
	#50;

// Permutation (r=01) Addition constante : a71b22fa2d0f5150 b11e0a9a608e0016 076f27ad4d99d506 a72ac1ad8440b0b7 0657b0d6eaf9c1c4

	state_i_s[0]=64'ha71b22fa2d0f5150 ;
	state_i_s[1]=64'hb11e0a9a608e0016 ;
	state_i_s[2]=64'h076f27ad4d99d506 ;
	state_i_s[3]=64'ha72ac1ad8440b0b7 ;
	state_i_s[4]=64'h0657b0d6eaf9c1c4 ;
end
endmodule : substitution_layer_tb
