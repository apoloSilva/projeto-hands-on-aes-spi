
// Modelo reservado: armazenamento ainda nao implementado.
module memory_model
    import aes_spi_pkg::*;
(
    input  logic                      clk,
    input  logic                      rst_n,

    input  logic                      mem_req,
    input  logic                      mem_we,
    input  logic [MEM_ADDR_WIDTH-1:0] mem_addr,
    input  logic [MEM_DATA_WIDTH-1:0] mem_wdata,
    input  logic [MEM_STRB_WIDTH-1:0] mem_wstrb,

    output logic [MEM_DATA_WIDTH-1:0] mem_rdata,
    output logic                      mem_ready
);

    // Valores temporarios 
    assign mem_rdata = '0;
    assign mem_ready = 1'b0;

endmodule