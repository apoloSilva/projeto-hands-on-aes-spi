
// IMPLEMENTAÇÃO DE TOPO: SEMANA 02

module minisoc_top
    import minisoc_pkg::*;
(
    // Interface: clock e reset
    input  logic clk, rst_n,

    // Interface: SPI IF
    input  logic spi_sclk,
    input  logic spi_cs_n,
    input  logic spi_mosi,
    output logic spi_miso,

    // Interface: MEMORY DATA
    input  logic                      mem_clk,
    input  logic [MEM_DATA_WIDTH-1:0] mem_i_data,
    input  logic                      mem_i_wr_en,
    input  logic [MEM_ADDR_WIDTH-1:0] mem_i_addr,
    output logic [MEM_DATA_WIDTH-1:0] mem_o_data
);

    // Clock e reset internos
    logic sys_clk, o_locked;
    logic rst_sys_n, rst_release_n;
    logic [1:0] rst_sync;

    // Registradores de configuração e estado
    logic [127:0] cfg_key, cfg_iv;
    logic [63:0]  cfg_counter;
    logic [31:0]  num_blocks, aes_control, aes_status;
    logic [31:0]  system_control;

    // Porta AES da memória (conexão interna)
    logic                      aes_mem_we;
    logic [MEM_ADDR_WIDTH-1:0] aes_mem_addr;
    logic [MEM_DATA_WIDTH-1:0] aes_mem_wdata;
    logic [MEM_DATA_WIDTH-1:0] aes_mem_rdata;

    // Seleção do proprietário da memória (Controle de memória)- Mem Mux
    logic                      mem_sel_aes;
    logic                      mem_mux_clk, mem_mux_we;
    logic [MEM_ADDR_WIDTH-1:0] mem_mux_addr;
    logic [MEM_DATA_WIDTH-1:0] mem_mux_wdata, mem_mux_rdata;

    assign mem_sel_aes   = system_control[0];
    assign mem_mux_clk   = mem_sel_aes ? sys_clk       : mem_clk;
    assign mem_mux_we    = mem_sel_aes ? aes_mem_we    : mem_i_wr_en;
    assign mem_mux_addr  = mem_sel_aes ? aes_mem_addr  : mem_i_addr;
    assign mem_mux_wdata = mem_sel_aes ? aes_mem_wdata : mem_i_data;

    assign aes_mem_rdata = mem_mux_rdata; // disponível tanto para o aes
    assign mem_o_data    = mem_mux_rdata; // quanto para MEMORY DATA 

    // 4.2 Sequência de reset interno
    assign rst_release_n = rst_n & o_locked;

    always_ff @(posedge sys_clk or negedge rst_release_n) begin
        if (!rst_release_n)
            rst_sync <= '0;
        else
            rst_sync <= {rst_sync[0], 1'b1};
    end

    assign rst_sys_n = rst_sync[1];

    // PLL
    minisoc_pll_mock u_minisoc_pll_mock (
        .rst_n       (rst_n),
        .clk_in      (clk),
        .pll_enable  (system_control[1]),
        .pll_div_sel (system_control[3:2]),
        .clk_out     (sys_clk),
        .o_locked    (o_locked)
    );

    // SPI e banco de registradores
    minisoc_spi u_minisoc_spi (
        // Clock, reset e estado da PLL
        .clk            (clk),     // clock always-on
        .rst_n          (rst_n),   // reset global
        .o_locked       (o_locked),
        // Interface: SPI IF
        .spi_sclk       (spi_sclk),
        .spi_mosi       (spi_mosi),
        .spi_miso       (spi_miso),
        .spi_cs_n       (spi_cs_n),
        // Configuração e estado
        .cfg_key        (cfg_key),
        .cfg_iv         (cfg_iv),
        .cfg_counter    (cfg_counter),
        .num_blocks     (num_blocks),
        .aes_control    (aes_control),
        .aes_status     (aes_status),
        .system_control (system_control)
    );

    // Controlador AES
    minisoc_aes_top u_minisoc_aes_top (
        // Clock, reset e estado da PLL
        .o_locked    (o_locked),
        .clk         (sys_clk),
        .rst_n       (rst_sys_n),

        // Configuração e estado
        .cfg_key     (cfg_key),
        .cfg_iv      (cfg_iv),
        .cfg_counter (cfg_counter),
        .num_blocks  (num_blocks),
        .aes_control (aes_control),
        .aes_status  (aes_status),

        // Porta de memória do AES
        .mem_we      (aes_mem_we),
        .mem_addr    (aes_mem_addr),
        .mem_wdata   (aes_mem_wdata),
        .mem_rdata   (aes_mem_rdata)
    );

    // Memória compartilhada: single-port
    minisoc_memory u_minisoc_memory (
        .clk   (mem_mux_clk),
        .wr_en (mem_mux_we),
        .addr  (mem_mux_addr),
        .wdata (mem_mux_wdata),
        .rdata (mem_mux_rdata)
    );

endmodule
