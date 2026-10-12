

module reg_bank
    import aes_spi_pkg::*;
(
    input  logic                      pll_locked,
    input  logic                      clk,
    input  logic                      rst_n,

    input  logic                      reg_write,
    input  logic [REG_ADDR_WIDTH-1:0] reg_addr,
    input  logic [REG_DATA_WIDTH-1:0] reg_data_in,
    output logic [REG_DATA_WIDTH-1:0] reg_data_out,

    output logic [REG_DATA_WIDTH-1:0] pll_config,
    output logic [REG_DATA_WIDTH-1:0] aes_config,
    input  logic [REG_DATA_WIDTH-1:0] aes_flags
);

    // Valores temporários
    assign reg_data_out = 8'h2F;
    assign pll_config   = '0;
    assign aes_config   = '0;

    // Lógica do banco de registradores reservada
    // para implementação posterior.

endmodule

