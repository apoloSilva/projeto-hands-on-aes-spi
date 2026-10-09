`timescale 1ns/1ps

module reset_ctrl (
    input  logic clk_sys,
    input  logic sclk,
    input  logic global_rst_n,
    input  logic pll_locked,
    output logic rst_sys_n,
    output logic rst_pll_n,
    output logic rst_spi_n
);
    logic async_rst_n;
    logic [1:0] sys_sync, spi_sync;

    assign async_rst_n = global_rst_n & pll_locked;

    // Assercao assincrona e liberacao sincronizada em cada dominio.
    always_ff @(posedge clk_sys or negedge async_rst_n) begin
        if (!async_rst_n)
            sys_sync <= '0;
        else
            sys_sync <= {sys_sync[0], 1'b1};
    end

    always_ff @(posedge sclk or negedge async_rst_n) begin
        if (!async_rst_n)
            spi_sync <= '0;
        else
            spi_sync <= {spi_sync[0], 1'b1};
    end

    assign rst_pll_n = global_rst_n;
    assign rst_sys_n = sys_sync[1];
    assign rst_spi_n = spi_sync[1];
endmodule
