
package aes_spi_pkg;

    // Parâmetros para escravo SPI.
    parameter int  SPI_DATA_WIDTH = 8;
    parameter int  SPI_WR_WIDTH   = 1;

    // Parâmetros para o banco de registradores.
    parameter int  NUM_REGS   = 4;
    localparam int REG_ADDR_WIDTH = $clog2(NUM_REGS);

    parameter int  REG_DATA_WIDTH = SPI_DATA_WIDTH - SPI_WR_WIDTH - REG_ADDR_WIDTH; // 1 bit de escrita, 2 bits de endereço e 4 bits de dados

    // Interface nativa de memoria; reservada para as proximas semanas.
    localparam int MEM_ADDR_WIDTH = 32;
    localparam int MEM_DATA_WIDTH = 32;
    localparam int MEM_STRB_WIDTH = MEM_DATA_WIDTH / 8; // Habilitar a escrita sobre todos os bytes

endpackage

