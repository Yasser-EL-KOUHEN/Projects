//l'Addition de constante 
// Yasser El Kouhen
// 13 mars 2024

import ascon_pack ::*;

module constant_addition
(
	input type_state state_i,
	input logic [3:0] round_i,
	output type_state state_o
);

//description de l'additionneur de cte

assign state_o[0]=state_i[0];
assign state_o[1]=state_i[1];
assign state_o[3]=state_i[3];
assign state_o[4]=state_i[4];

assign state_o[2][63:8]=state_i[2][63:8];
assign state_o[2][7:0]=state_i[2][7:0]^round_constant[round_i];   //^=XOR

endmodule : constant_addition
