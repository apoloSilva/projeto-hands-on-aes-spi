
module stimulus
    import aes_spi_pkg::*;
(
    output logic clk_osc,
    output logic global_rst_n,
    output logic sclk,
    output logic cs_n,
    output logic mosi,
    output logic check,
    output logic done
);
    localparam logic [SPI_DATA_WIDTH-1:0] MOSI_DATA = 8'hD3;

    initial clk_osc = 1'b0;
    always #5 clk_osc = ~clk_osc;

    initial begin
        global_rst_n = 1'b0;
        sclk = 1'b0;
        cs_n = 1'b1;
        mosi = 1'b0;
        check = 1'b0;
        done = 1'b0;

        #20;
        global_rst_n = 1'b1;

        // Clocks com CS inativo para liberar o reset sincronizado do SPI.
        repeat (4) begin
            #10;
            sclk = 1'b1 & (~cs_n);
            #10;
            sclk = 1'b0 & (~cs_n);
        end

        #10;
        cs_n = 1'b0;

        // Envia a palavra em MOSI, MSB primeiro.
        for (int i = SPI_DATA_WIDTH-1; i >= 0; i--) begin
            mosi = MOSI_DATA[i];
            #10;
            sclk = 1'b1;
            #10;
            sclk = 1'b0;
        end

        #2;
        check = 1'b1; // sinal de verificação para response_checker
        #1;
        check = 1'b0;
        cs_n = 1'b1;
        #5;
        done = 1'b1; // sinal de finalização para response_checker
    end

endmodule
