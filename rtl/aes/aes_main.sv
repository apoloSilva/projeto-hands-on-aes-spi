
// Bloco reservado. AES e acessos à memória ainda não estão implementados.
module aes_main
    import aes_spi_pkg::*;
(
    input  logic                      pll_locked,
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic [REG_DATA_WIDTH-1:0] aes_config,
    output logic [REG_DATA_WIDTH-1:0] aes_flags,

    output logic                      mem_req,
    output logic                      mem_we,
    output logic [MEM_ADDR_WIDTH-1:0] mem_addr,
    output logic [MEM_DATA_WIDTH-1:0] mem_wdata,
    output logic [MEM_STRB_WIDTH-1:0] mem_wstrb, // Memory Strobe Width
    input  logic [MEM_DATA_WIDTH-1:0] mem_rdata,
    input  logic                      mem_ready
);

    // Valores temporários até a implementação do AES
    assign aes_flags = '0;

    // Interface de memória desativada temporariamente
    assign mem_req   = 1'b0;
    assign mem_we    = 1'b0;
    assign mem_addr  = '0;
    assign mem_wdata = '0;
    assign mem_wstrb = '0;

endmodule

