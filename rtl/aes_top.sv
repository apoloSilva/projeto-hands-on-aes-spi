
// Teste minimo de ambiente da Semana 1.
// ATENCAO: Este modulo NÃO implementa AES nem criptografia.
// Ele somente recebe e devolve de forma serial um bloco de bits para validar
// o ambiente de compilacão, lint, simulacão, reset e sinais de controle do testbench.

module aes_top
    import aes_spi_pkg::*;
(
    input  logic clk_osc,
    input  logic global_rst_n,

    // Interface SPI externa
    input  logic sclk,
    input  logic cs_n,
    input  logic mosi,
    output logic miso,

    // Interface padrão síncrona de memoria (somente conexões nesta etapa).
    output logic                       mem_clk,
    output logic                       mem_rst_n,
    output logic                       mem_req,
    output logic                       mem_we,
    output logic [MEM_ADDR_WIDTH-1:0]  mem_addr,
    output logic [MEM_DATA_WIDTH-1:0]  mem_wdata,
    output logic [MEM_STRB_WIDTH-1:0]  mem_wstrb,
    input  logic [MEM_DATA_WIDTH-1:0]  mem_rdata,
    input  logic                       mem_ready
);
    logic clk_sys, pll_locked;
    logic rst_sys_n, rst_pll_n, rst_spi_n;
    logic [SPI_DATA_WIDTH-1:0] aes_flags, aes_config, pll_config;

    // Modelo semana 1: apenas repassa o reset global para os outros sinais de reset
    reset_ctrl u_reset_ctrl (
        .clk_sys      (clk_sys),
        .sclk         (sclk),
        .global_rst_n (global_rst_n),
        .pll_locked   (pll_locked),
        .rst_sys_n    (rst_sys_n),
        .rst_pll_n    (rst_pll_n)
		);

    // Modelo semana 1: repassa o clock, sem multiplicacão de frequência.
    pll_model u_pll_model (
        .rst_n      (rst_pll_n),
        .clk_in     (clk_osc),
        .pll_config (pll_config),
        .clk_out    (clk_sys),
        .pll_locked (pll_locked)
    );

    // Modelo semana 1: teste de registrador de deslocamento do spi
    spi_subnode u_spi_subnode (
        .pll_locked (pll_locked),
        .sclk       (sclk),
        .cs_n       (cs_n),
        .mosi       (mosi),
        .miso       (miso),
        .clk_sys    (clk_sys),
        .rst_sys_n  (rst_sys_n),
        .aes_flags  (aes_flags),
        .aes_config (aes_config),
        .pll_config (pll_config)
    );

    // Modelo semana 1: sem implementação lógica
    aes_main u_aes_main (
        .pll_locked (pll_locked),
        .clk        (clk_sys),
        .rst_n      (rst_sys_n),
        .aes_flags  (aes_flags),
        .aes_config (aes_config),
        .mem_req    (mem_req),
        .mem_we     (mem_we),
        .mem_addr   (mem_addr),
        .mem_wdata  (mem_wdata),
        .mem_wstrb  (mem_wstrb),
        .mem_rdata  (mem_rdata),
        .mem_ready  (mem_ready)
    );

    assign mem_clk   = clk_sys;
    assign mem_rst_n = rst_sys_n;
endmodule

