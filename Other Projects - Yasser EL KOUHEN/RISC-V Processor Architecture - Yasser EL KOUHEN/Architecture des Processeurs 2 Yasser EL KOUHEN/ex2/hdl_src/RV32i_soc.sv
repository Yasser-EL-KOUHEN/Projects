


module RV32i_soc #(




    parameter string IMEM_INIT_FILE = "../firmware/imem.hex",
    string DMEM_INIT_FILE = ""








) (
    input  logic clk_i,

    input  logic resetn_i





);

  localparam IMEM_BASE_ADDR = 32'h0000_0000;
  localparam IMEM_SIZE = 4096;

  localparam DMEM_BASE_ADDR = 32'h0001_0000;
  localparam DMEM_SIZE = 4096;







  logic [31:0] imem_data_w;
  logic [31:0] imem_add_w;
  logic [31:0] dmem_add_w;
  logic [31:0] dmem_di_w;
  logic [31:0] do_w, dmem_do_w;
  logic [3:0] ble_w;
  logic we_w, imem_we_w;
  logic dmem_re_w, imem_re_w;
  logic dmem_cs_w, imem_cs_w;





  //address decoding
  assign imem_cs_w = (imem_add_w >= IMEM_BASE_ADDR) && (imem_add_w < (IMEM_BASE_ADDR + IMEM_SIZE));
  assign dmem_cs_w = (dmem_add_w >= DMEM_BASE_ADDR) && (dmem_add_w < (DMEM_BASE_ADDR + DMEM_SIZE));





  RV32i_top RV32i_core (
      .clk_i(clk_i),
      .resetn_i(resetn_i),
      .imem_add_o(imem_add_w),
      .imem_data_i(imem_data_w),
      .dmem_add_o(dmem_add_w),
      .dmem_do_i(do_w),
      .dmem_di_o(dmem_di_w),
      .dmem_we_o(we_w),
      .dmem_re_o(re_w),
      .dmem_ble_o(ble_w)
  );

  assign imem_re_w = imem_cs_w;
  wsync_mem #(
      .SIZE(4096),
      .INIT_FILE(IMEM_INIT_FILE)
  ) imem (
      .clk_i(clk_i),
      .we_i (1'b0),
      .re_i (imem_re_w),
      .ble_i(4'b1111),
      .d_i  (32'h0),
      .add_i(imem_add_w[13:2]),
      .d_o  (imem_data_w)
  );


  assign dmem_we_w = we_w & dmem_cs_w;
  assign dmem_re_w = re_w & dmem_cs_w;
  wsync_mem #(
      .SIZE(4096),
      .INIT_FILE(DMEM_INIT_FILE)
  ) dmem (
      .clk_i(clk_i),
      .we_i (dmem_we_w),
      .re_i (dmem_re_w),
      .ble_i(ble_w),
      .d_i  (dmem_di_w),
      .add_i(dmem_add_w[13:2]),
      .d_o  (dmem_do_w)
  );

















  // data out multiplexer

  assign do_w = (dmem_cs_w == 1'b1)? dmem_do_w:32'h0;







endmodule
