//module permutation sans xor
//Yasser EL KOUHEN
//10 mai 2024

import ascon_pack::*;

module permutation 
(
	input type_state state_i,
	input logic sel_i,
	input logic [3:0] round_i,
	input logic clock_i,
 	input logic resetb_i,
 	input logic en_i,
	output type_state state_o
);

type_state mux_to_state_s, cst_to_sub_s, sub_to_lin_s, lin_to_register_s;

mux_state mux (
	.sel_i(sel_i),
	.data1_i(state_i),
	.data2_i(state_o),
	.data_o(mux_to_state_s)
);

constant_addition pc (
	.state_i(mux_to_state_s),
	.round_i(round_i),
	.state_o(cst_to_sub_s)
);

substitution_layer ps (
	.state_i(cst_to_sub_s),
	.state_o(sub_to_lin_s)
);

diffusion_lin pl (
	.state_i(sub_to_lin_s),
	.state_o(lin_to_register_s)
);

state_register_w_en state_reg(
	.clock_i(clock_i),
 	.resetb_i(resetb_i),
 	.en_i(en_i),
	.data_i(lin_to_register_s),
 	.data_o(state_o)
 ) ;

endmodule : permutation










