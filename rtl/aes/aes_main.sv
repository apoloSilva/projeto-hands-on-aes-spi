`timescale 1ns/1ps

// Bloco reservado. AES e acessos a memoria ainda não estao implementados.
module aes_main
    import aes_spi_pkg::*;
(
    input  logic                      pll_locked,
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic [REG_DATA_WIDTH-1:0] aes_config,
    output logic [REG_DATA_WIDTH-1:0] aes_flags,

    output logic                       mem_req,
    output logic                       mem_we,
    output logic [MEM_ADDR_WIDTH-1:0]  mem_addr,
    output logic [MEM_DATA_WIDTH-1:0]  mem_wdata,
    output logic [MEM_STRB_WIDTH-1:0]  mem_wstrb, // Memory Strobe Width
    input  logic [MEM_DATA_WIDTH-1:0]  mem_rdata,
    input  logic                       mem_ready
);


endmodule
