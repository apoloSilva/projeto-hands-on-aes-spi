
module spi_base
    import aes_spi_pkg::*;
(
    input  logic sclk, rst_n,
    input  logic cs_n, mosi,
    output logic miso,

    output logic [SPI_DATA_WIDTH-1:0] rx_data,
    input  logic [SPI_DATA_WIDTH-1:0] tx_data,

    output logic rx_ready,
    input  logic tx_ready
);

    logic [SPI_DATA_WIDTH-1:0] rx_shift_reg;

    // Conexões temporárias
    assign rx_data  = rx_shift_reg;
    assign rx_ready = 1'b0;

    // Teste mínimo: recepção serial
    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n)
            rx_shift_reg <= '0;
        else if (!cs_n)
            rx_shift_reg <= {rx_shift_reg[SPI_DATA_WIDTH-2:0], mosi};
    end

    // Saída serial temporária
    always_ff @(negedge sclk or negedge rst_n) begin
        if (!rst_n)
            miso <= 1'b0;
        else if (!cs_n)
            miso <= rx_shift_reg[0];
        else
            miso <= 1'b0;
    end

endmodule

