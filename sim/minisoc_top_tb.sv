


module minisoc_top_tb;
    import minisoc_pkg::*;


    // FIPS 197-upd1, Apêndice B: chave, entrada e saída final do AES-128.
    localparam logic [127:0] AES_KEY    = 128'h2B7E151628AED2A6ABF7158809CF4F3C;
    localparam logic [127:0] PLAINTEXT  = 128'h3243F6A8885A308D313198A2E0370734;
    localparam logic [127:0] CIPHERTEXT = 128'h3925841D02DC09FBDC118597196A0B32;


    logic clk_ref = 1'b0;
    logic clk_sys, o_locked;
    logic rst_n, rst_aes_n;
    logic [31:0] aes_control, aes_status;
    logic [127:0] input_block, output_block;


    // Referência de 2 GHz (período de 500 ps).
    always #250ps clk_ref = ~clk_ref;


    minisoc_pll_mock u_minisoc_pll_mock (
        .rst_n       (rst_n),
        .clk_in      (clk_ref),
        .pll_div_sel (2'b11), // /8: 250 MHz para o AES.
        .clk_out     (clk_sys),
        .o_locked    (o_locked)
    );


    // DUT: FSM, expansão de chave e datapath do topo AES.
    minisoc_aes_top u_minisoc_aes_top (
        .o_locked    (o_locked),
        .clk         (clk_sys),
        .rst_n       (rst_aes_n),
        .cfg_key     (AES_KEY),
        .cfg_iv      (128'b0),
        .cfg_counter (64'b0),
        .num_blocks  (32'd1),
        .aes_control (aes_control),
        .aes_status  (aes_status),
        .mem_we      (),
        .mem_addr    (),
        .mem_wdata   (),
        .mem_rdata   ('0),
        .state_in    (input_block),
        .state_out   (output_block)
    );


    // Execução dos testes.
    initial begin
`ifdef FSDB
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, minisoc_top_tb);
`endif
        rst_n       = 1'b0;
        rst_aes_n   = 1'b0;
        aes_control = '0;
        input_block = '0;
        repeat (2) @(negedge clk_ref);
        rst_n = 1'b1;
        repeat (RESET_RELEASE_CYCLES) @(negedge clk_sys);
        rst_aes_n = 1'b1;


        $display("\nTESTANDO: CIPHER()");
        check_cypher(PLAINTEXT, CIPHERTEXT);


        $display("\nTESTANDO: INVCIPHER()");
        check_inv_cypher(CIPHERTEXT, PLAINTEXT);


        $finish;
    end


    // Rotinas de verificação.
    task automatic check_cypher (
        input logic [127:0] block_in,
        input logic [127:0] expected
    );
        @(negedge clk_sys);
        input_block = block_in;
        aes_control = 32'h0000_0001; // ECB, cifragem e START.
        @(negedge clk_sys);
        aes_control[0] = 1'b0;
        @(posedge aes_status[1]);


        if (output_block !== expected)
            $fatal(1, "FAIL CIPHER: esperado=%032h obtido=%032h", expected, output_block);


        $display("PASS CIPHER");
    endtask


    task automatic check_inv_cypher (
        input logic [127:0] block_in,
        input logic [127:0] expected
    );
        @(negedge clk_sys);
        input_block = block_in;
        aes_control = 32'h0000_0003; // ECB, decifragem e START.
        @(negedge clk_sys);
        aes_control[0] = 1'b0;
        @(posedge aes_status[1]);


        if (output_block !== expected)
            $fatal(1, "FAIL INVCIPHER: esperado=%032h obtido=%032h", expected, output_block);


        $display("PASS INVCIPHER");
    endtask
endmodule





