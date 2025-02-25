//permutation élémentaire p, p= pl o ps o pc
//Yasser EL KOUHEN
//10 mai 2024

import ascon_pack::*;

module permutation_elementaire 
(
	input type_state state_i,
	input logic [3:0] round_i,
	output type_state state_o
);

type_state cst_to_sub_s, sub_to_lin_s;

constant_addition pc (
	.state_i(state_i),
	.round_i(round_i),
	.state_o(cst_to_sub_s)
);

substitution_layer ps (
	.state_i(cst_to_sub_s),
	.state_o(sub_to_lin_s)
);

diffusion_lin pl (
	.state_i(sub_to_lin_s),
	.state_o(state_o)
);

endmodule : permutation_elementaire
