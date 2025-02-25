//Testbench du module ASCON_top
//Yasser EL KOUHEN
//13 mai 2024

`timescale 1ns / 1ps
import ascon_pack ::*;

module ascon_top_tb
(
	//empty declarative part
);
	logic resetb_i_s;
	logic [63:0] data_i_s, cipher_o_s;
	logic [127:0] key_i_s, nonce_i_s, tag_o_s;
	logic start_i_s, end_o_s;
	logic data_valid_i_s, cipher_valid_o_s;
	logic [63:0] P1_s, P2_s, P3_s;
	logic [63:0] A1_s;

	logic clock_i_s=1'b1;

	ascon_top DUT (
    		.clock_i(clock_i_s), 
		.resetb_i(resetb_i_s),
		.data_i(data_i_s),
		.data_valid_i(data_valid_i_s),
		.key_i(key_i_s), 
		.nonce_i(nonce_i_s),
    		.start_i(start_i_s),
		.cipher_o(cipher_o_s),
		.cipher_valid_o(cipher_valid_o_s),
		.tag_o(tag_o_s),
    		.end_o(end_o_s)
	);
always begin 	//clock_i_s de période 50ns
        #25;
        assign clock_i_s = ~clock_i_s;
    end

initial begin
 // reset et du start
        start_i_s = 1'b0;
        resetb_i_s = 1'b0;
        //data_valid_i_s = 1'b0;

        // Initialisation
        data_i_s = 64'h80400C0600000000; 
        key_i_s = 128'h8a55114d1cb6a9a2be263d4d7aecaaff;
        nonce_i_s = 128'h4ed0ec0b98c529b7c8cddf37bcd0284a; 

        P1_s = 64'h5244562061752054;
        P2_s = 64'h6927626172206365;
        P3_s = 64'h20736f6972203f80;
	A1_s = 64'h4120746f20428000; 

        #2;
        resetb_i_s = 1'b1;
        
	//conf_init
        #48; 
        start_i_s = 1'b1;
        data_valid_i_s = 1'b1;

        #50;
        start_i_s = 1'b0;

        #500;
	
	//da_rd0 
        data_i_s = A1_s; 
        #50;

        data_valid_i_s = 1'b1;
        #50;

        //data_valid_i_s = 1'b0;
        #150; 

	//tc_rd0 with blocs=0
        data_i_s = P1_s; 
        #50;

        data_valid_i_s = 1'b1;
        #50;

        //data_valid_i_s = 1'b0;
        #150;

	//tc_rd0 with blocs=1
        data_i_s = P2_s; 
        #50;

        data_valid_i_s = 1'b1;
        #50;

        //data_valid_i_s = 1'b0;
        #150;
	
	//finalisation_rd0
        data_i_s = P3_s; 
        #50;

        data_valid_i_s = 1'b1;
        #50;

        //data_valid_i_s = 1'b0;
        #150;
end
endmodule : ascon_top_tb





