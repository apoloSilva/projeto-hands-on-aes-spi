
module response_checker
    import aes_spi_pkg::*;
(
    input logic clk_osc,
    input logic global_rst_n,
    input logic sclk,
    input logic cs_n,
    input logic miso,
    input logic check,
    input logic done
);
    localparam logic [SPI_DATA_WIDTH-1:0] EXPECTED_DATA = 8'hD3;

    logic [SPI_DATA_WIDTH-1:0] received_miso;
    int number_of_bits;
    int number_of_tests = 0;
    int number_of_errors = 0;

    // Captura MISO depois da atualizacao na borda de descida.
    always @(negedge sclk or negedge global_rst_n) begin
        if (!global_rst_n) begin
            received_miso <= '0;
            number_of_bits <= 0;
        end
        else if (!cs_n) begin
            #1;
            received_miso <= {received_miso[SPI_DATA_WIDTH-2:0], miso};
            number_of_bits <= number_of_bits + 1;
        end
    end

    always @(posedge check) begin
        number_of_tests++;

        if (received_miso !== EXPECTED_DATA ||
            number_of_bits != SPI_DATA_WIDTH) begin
            number_of_errors++;
            $display("ERROR: MISO=%h expected=%h | bits=%0d",
                     received_miso, EXPECTED_DATA, number_of_bits);
        end
        else begin
            $display("PASS: MISO=%h", received_miso);
        end
    end

    always @(posedge done) begin
        $display("Tests: %0d | Errors: %0d", number_of_tests, number_of_errors);
        if (number_of_tests == 0 || number_of_errors != 0)
            $fatal(1, "TEST FAILED");
        else
            $display("TEST PASSED");
    end

endmodule
