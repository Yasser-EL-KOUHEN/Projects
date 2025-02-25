//Sbox
//Yasser EL KOUHEN
//20 mars 2024


import ascon_pack::*;

module ascon_sbox
(
	input logic [4:0] sbox_i,
	output logic [4:0] sbox_o
);

assign sbox_o = sbox_t[sbox_i];

endmodule : ascon_sbox

