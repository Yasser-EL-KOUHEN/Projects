//TB de la sbox
// Yasser El Kouhen
// 20 mars 2024

import ascon_pack ::*;

`timescale 1ns / 1ps
module ascon_sbox_tb
(
	//empty declarative part
);

	logic [4:0] sbox_i_s, sbox_o_s;

	ascon_sbox DUT (
		.sbox_i(sbox_i_s),
		.sbox_o(sbox_o_s)
	);

initial begin 
	#0 sbox_i_s=0'h00;
	repeat (31) begin
		#50 sbox_i_s++;
	end
end
endmodule : ascon_sbox_tb 
