module cache #(
    localparam ByteOffsetBits = /* TODO */,
    localparam IndexBits = /* TODO */,
    localparam TagBits = /* TODO */,

    localparam NrWordsPerLine = /* TODO */,
    localparam NrLines = /* TODO */,

    localparam LineSize = 32 * NrWordsPerLine
) (
    input logic clk_i,
    input logic rstn_i,

    input logic [31:0] addr_i,

    // Read port
    input logic read_en_i,
    output logic read_valid_o,
    output logic [31:0] read_word_o,

    // Memory
    output logic [31:0] mem_addr_o,

    // Memory read port
    output logic mem_read_en_o,
    input logic mem_read_valid_i,
    input logic [LineSize-1:0] mem_read_data_i
);

/* TODO */

endmodule
