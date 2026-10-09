module spi_main
    import aes_spi_pkg::*;
(
    input  logic pll_locked,
    input  logic sclk, cs_n, mosi,
    output logic miso,
    input  logic clk_sys,
    input  logic rst_spi_n,
    input  logic rst_sys_n,
    input  logic [REG_DATA_WIDTH-1:0] aes_flags,
    output logic [REG_DATA_WIDTH-1:0] aes_config, // deve ser registrada
    output logic [REG_DATA_WIDTH-1:0] pll_config // deve ser registrada
);
    logic                      reg_write; // Controle de escrita
    logic [REG_ADDR_WIDTH-1:0] reg_addr;
    logic [REG_DATA_WIDTH-1:0] reg_data_in, reg_data_out;

    // define os modos de operação do SPI
    logic [REG_DATA_WIDTH-1:0] spi_modes; //  CPOL e CPHA

    // Registrador de deslocamento para recepcao serial.
    logic [REG_DATA_WIDTH-1:0] shift_reg;
     
    // SPI FSM e CDC completos ficam reservados para as proximas semanas
    // spi_fsm u_spi_fsm (...);
    // spi_cdc u_spi_cdc (...);

    reg_bank u_reg_bank (
        .clk        (clk_sys),
        .rst_n      (rst_sys_n),
        .reg_write  (reg_write),
        .reg_addr   (reg_addr),
        .data_in    (reg_data_in),
        .data_out   (reg_data_out)
    );

    assign reg_write   = 1'b0;
    assign reg_addr    = '0;
    assign reg_data_in = '0;

    // Desloca os bits para a esquerda e insere MOSI no bit menos significativo.
    always_ff @(posedge sclk or negedge rst_spi_n) begin
        if (!rst_spi_n)
            shift_reg <= '0;
        else if (!cs_n)
            shift_reg <= {shift_reg[REG_DATA_WIDTH-2:0], mosi};
    end

    // De forma independente, os bits de shift_reg são passados a MISO
    always_ff @(negedge sclk or negedge rst_spi_n) begin
        if (!rst_spi_n)
            miso <= 1'b0;
        else if (!cs_n)
            miso <= shift_reg[0];
        else
            miso <= 1'b0;
    end

endmodule