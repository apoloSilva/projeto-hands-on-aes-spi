`timescale 1ns/1ps

package aes_spi_pkg;
    // Parâmetros para o banco de registradores.
    parameter int  REG_DATA_WIDTH = 8;
    parameter int  NUM_REGS   = 4;
    localparam int REG_ADDR_WIDTH = $clog2(NUM_REGS);

    // Interface nativa de memoria; reservada para as proximas semanas.
    localparam int MEM_ADDR_WIDTH = 32;
    localparam int MEM_DATA_WIDTH = 32;
    localparam int MEM_STRB_WIDTH = MEM_DATA_WIDTH / 8; // Habilitar a escrita sobre todos os bytes
endpackage
