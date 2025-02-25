//Testbench de l'opération de diffusion linéaire
//Yasser EL KOUHEN
//27 mars 2024

import ascon_pack ::*;

`timescale 1ns / 1ps
module diffusion_lin_tb
(
	//empty declarative part
);

	type_state state_i_s, state_o_s;

	diffusion_lin DUT (
		.state_i(state_i_s),
		.state_o(state_o_s)
	);

// Permutation (r=00) Substitution S-box : 78e2cc41faabaa1a bc7a2e775aababf7 4b81c0cbbdb5fc1a b22e133e424f0250 044d33702433805d

initial begin
	state_i_s[0]=64'h78e2cc41faabaa1a ;
	state_i_s[1]=64'hbc7a2e775aababf7 ;
	state_i_s[2]=64'h4b81c0cbbdb5fc1a ;
	state_i_s[3]=64'hb22e133e424f0250 ;
	state_i_s[4]=64'h044d33702433805d ;
	#50;

// Permutation (r=01) Substitution S-box : 1642cee0845634e5 17397d1b2a296525 49dbe29ab8516baf 110e5ecc42a8a463 b16f79e94eb17171

	state_i_s[0]=64'h1642cee0845634e5 ;
	state_i_s[1]=64'h17397d1b2a296525 ;
	state_i_s[2]=64'h49dbe29ab8516baf ;
	state_i_s[3]=64'h110e5ecc42a8a463 ;
	state_i_s[4]=64'hb16f79e94eb17171 ;
end
endmodule : diffusion_lin_tb
