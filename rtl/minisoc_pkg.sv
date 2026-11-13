package minisoc_pkg;

    // Parâmetros para escravo SPI.
    parameter int SPI_FRAME_WIDTH = 40;

    parameter int SPI_MODE = 0; // SPI Mode 0: CPOL = 0 e CPHA = 0

    // Interface nativa de memoria; reservada para as proximas semanas.
    localparam int MEM_ADDR_WIDTH = 10;
    localparam int MEM_DATA_WIDTH = 32;

    typedef enum logic [3:0] {
        ST_IDLE          = 4'd0,
        ST_CHECK         = 4'd1,
        ST_KEY_EXPANSION = 4'd2,
        ST_READ_BLOCK    = 4'd3,
        ST_LOAD_STATE    = 4'd11,
        ST_ADD_ROUND_KEY = 4'd4,
        ST_SUB_BYTES     = 4'd5,
        ST_SHIFT_ROWS    = 4'd6,
        ST_MIX_COLUMNS   = 4'd7,
        ST_WRITE_BLOCK   = 4'd8,
        ST_CHECK_BLOCKS  = 4'd12,
        ST_DONE          = 4'd9,
        ST_ERROR         = 4'd10
    } state_t;
    

    parameter int unsigned RESET_RELEASE_CYCLES = 2;

endpackage

