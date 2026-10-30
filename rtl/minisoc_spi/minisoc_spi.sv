
module minisoc_spi
    import minisoc_pkg::*;
(
    // Clock, reset e estado da PLL
    input  logic         clk,
    input  logic         rst_n,
    input  logic         o_locked,

    input  logic         spi_sclk,
    input  logic         spi_cs_n,
    input  logic         spi_mosi,
    output logic         spi_miso,

    // Registradores
    output logic [127:0] cfg_key,
    output logic [127:0] cfg_iv,
    output logic [63:0]  cfg_counter,
    output logic [31:0]  num_blocks, // número de blocos de 128 bits que o AES deve processar ao receber START 
    output logic [31:0]  aes_control,
    input  logic [31:0]  aes_status,
    output logic [31:0]  system_control
);






endmodule
