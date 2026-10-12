
module spi_cdc
    import aes_spi_pkg::*;
(
    // Clock and reset
    input  logic sclk,
    input  logic clk_sys,
    input  logic rst_sys_n,

    // SPI interface
    input  logic [SPI_DATA_WIDTH-1:0] rx_data,
    output logic [SPI_DATA_WIDTH-1:0] tx_data,
    input  logic                      rx_ready,
    output logic                      tx_ready,

    // Register bank interface
    output logic                      reg_write,
    output logic [REG_ADDR_WIDTH-1:0] reg_addr,
    output logic [REG_DATA_WIDTH-1:0] reg_data_in,
    input  logic [REG_DATA_WIDTH-1:0] reg_data_out
);

    // Temporary assignments
    assign tx_data     = '0;
    assign tx_ready    = 1'b0;
    assign reg_write   = 1'b0;
    assign reg_addr    = '0;
    assign reg_data_in = '0;

    // TODO: Implement CDC logic

endmodule

