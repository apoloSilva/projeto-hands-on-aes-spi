
module testbench;
    import aes_spi_pkg::*;

    logic clk_osc, global_rst_n;
    logic sclk, cs_n, mosi, miso;

    logic check, done;

    // Interface padrão síncrona de memoria (somente conexões nesta etapa).
    logic mem_clk, mem_rst_n, mem_req, mem_we, mem_ready;
    logic [MEM_ADDR_WIDTH-1:0]  mem_addr;
    logic [MEM_DATA_WIDTH-1:0]  mem_wdata, mem_rdata;
    logic [MEM_STRB_WIDTH-1:0]  mem_wstrb;

    // Gera os estímulos
    stimulus stimulus_inst (
        .clk_osc       (clk_osc),
        .global_rst_n  (global_rst_n),
        .sclk          (sclk),
        .cs_n          (cs_n),
        .mosi          (mosi),
        .check         (check),
        .done          (done)
    );

    // Teste do sistema top level
    aes_top dut_top (
        .clk_osc(clk_osc), .global_rst_n(global_rst_n),
        .sclk(sclk), .cs_n(cs_n), .mosi(mosi), .miso(miso),

        // Interface padrão síncrona de memoria  não verificada
        .mem_clk(mem_clk), .mem_rst_n(mem_rst_n), .mem_req(mem_req), .mem_we(mem_we),
        .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata), .mem_ready(mem_ready)
    );

    // Também podemos testar diretamente o subsistema aes e SPI; dedicado a outras semanas
    // aes_main dut_aes(...);
    // spi_main dut_spi(...);

    // Memoria externa: somente preenchimento da estrutura.
    memory_model u_memory_model (
        .clk       (mem_clk),
        .rst_n     (mem_rst_n),
        .mem_req   (mem_req),
        .mem_we    (mem_we),
        .mem_addr  (mem_addr),
        .mem_wdata (mem_wdata),
        .mem_wstrb (mem_wstrb),
        .mem_rdata (mem_rdata),
        .mem_ready (mem_ready)
    );

    response_checker response_checker_inst (
        .clk_osc       (clk_osc),
        .global_rst_n  (global_rst_n),
        .sclk          (sclk),
        .cs_n          (cs_n),
        .miso          (miso),
        .check         (check),
        .done          (done)
    );

    initial begin
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, testbench);

        #1000;
        $fatal(1, "Simulation timeout.");
    end

    always @(posedge done) begin
        #1;
        $finish;
    end

endmodule
