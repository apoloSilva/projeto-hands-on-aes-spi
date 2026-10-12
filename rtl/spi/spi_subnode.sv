
module spi_subnode
    import aes_spi_pkg::*;
(
    input  logic pll_locked,
    input  logic sclk, cs_n, mosi,
    output logic miso,

    input  logic clk_sys, rst_sys_n,

    output logic [REG_DATA_WIDTH-1:0] pll_config, aes_config,
    input  logic [REG_DATA_WIDTH-1:0] aes_flags
);

    // Interface com o banco de registradores
    logic                      reg_write;
    logic [REG_ADDR_WIDTH-1:0] reg_addr;
    logic [REG_DATA_WIDTH-1:0] reg_data_in, reg_data_out;

    // Controle do SPI base
    logic rx_ready, tx_ready;

    // Dados recebidos e transmitidos
    logic [SPI_DATA_WIDTH-1:0] rx_data, tx_data;

    // ==========================================
    // SPI Base
    // ==========================================

    spi_base u_spi_base (
        .sclk       (sclk),
        .rst_n      (rst_sys_n),
        .cs_n       (cs_n),
        .mosi       (mosi),
        .miso       (miso),

        .rx_data    (rx_data),
        .tx_data    (tx_data),
        .rx_ready   (rx_ready),
        .tx_ready   (tx_ready)
    );

    // ==========================================
    // Clock Domain Crossing
    // ==========================================

    spi_cdc u_spi_cdc (
        .sclk         (sclk),
        .clk_sys      (clk_sys),
        .rst_sys_n    (rst_sys_n),

        .rx_data      (rx_data),
        .tx_data      (tx_data),
        .rx_ready     (rx_ready),
        .tx_ready     (tx_ready),

        .reg_write    (reg_write),
        .reg_addr     (reg_addr),
        .reg_data_in  (reg_data_in),
        .reg_data_out (reg_data_out)
    );

    // ==========================================
    // Register Bank
    // ==========================================

    reg_bank u_reg_bank (
        .pll_locked   (pll_locked),
        .clk          (clk_sys),
        .rst_n        (rst_sys_n),
        .reg_write    (reg_write),
        .reg_addr     (reg_addr),
        .reg_data_in  (reg_data_in),
        .reg_data_out (reg_data_out),
        .pll_config   (pll_config),
        .aes_flags    (aes_flags),
        .aes_config   (aes_config)
    );

endmodule

