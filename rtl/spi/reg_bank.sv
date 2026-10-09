`timescale 1ns/1ps

module reg_bank
	import aes_spi_pkg::*;
(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  reg_write,
    input  logic [REG_ADDR_WIDTH-1:0] reg_addr,
    input  logic [REG_DATA_WIDTH-1:0] data_in,
    output logic [REG_DATA_WIDTH-1:0] data_out
);


// Valores temporarios originais
assign data_out   = 8'h2F;


endmodule
