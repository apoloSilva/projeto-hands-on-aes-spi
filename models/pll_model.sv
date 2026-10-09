
// Modelo temporario
module pll_model
    import aes_spi_pkg::*;
(
    input  logic                  rst_n,
    input  logic                  clk_in,
    input  logic [REG_DATA_WIDTH-1:0] pll_config,
    output logic                  clk_out,
    output logic                  pll_locked
);
    assign clk_out    = clk_in;
    assign pll_locked = rst_n;

endmodule
