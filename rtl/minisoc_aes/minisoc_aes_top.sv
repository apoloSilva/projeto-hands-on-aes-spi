
module minisoc_aes_top
    import minisoc_pkg::*;
(
    input  logic                      o_locked,
    input  logic                      clk,
    input  logic                      rst_n,

    // Configuração e estado
    input  logic [127:0]              cfg_key,
    input  logic [127:0]              cfg_iv,
    input  logic [63:0]               cfg_counter,
    input  logic [31:0]               num_blocks,
    input  logic [31:0]               aes_control,
    output logic [31:0]               aes_status,

    // Interface de memória
    output logic                      mem_we,
    output logic [MEM_ADDR_WIDTH-1:0] mem_addr,
    output logic [MEM_DATA_WIDTH-1:0] mem_wdata,
    input  logic [MEM_DATA_WIDTH-1:0] mem_rdata
);

endmodule
