module minisoc_aes_top
    import minisoc_pkg::*;
(
    input  logic                      o_locked,
    input  logic                      clk,
    input  logic                      rst_n,

    // Configuração e estado
    input  logic [127:0]              cfg_key,
    input  logic [127:0]              cfg_iv,
    input  logic [63:0]               cfg_counter,
    input  logic [31:0]               num_blocks,
    input  logic [31:0]               aes_control,
    output logic [31:0]               aes_status,

    // Interface de memória
    output logic                      mem_we,
    output logic [MEM_ADDR_WIDTH-1:0] mem_addr,
    output logic [MEM_DATA_WIDTH-1:0] mem_wdata,
    input  logic [MEM_DATA_WIDTH-1:0] mem_rdata
);

    // Registradores e sinais internos

    state_t state_q;

    logic [3:0]   round_q;
    logic [1:0]   word_q;
    logic [8:0]   block_q, blocks_done_q;

    logic [127:0] key_q;
    logic [31:0]  num_blocks_q;
    logic [2:0]   mode_q;
    logic [127:0] memory_block_q;

    logic [127:0] round_key, result_block;

    logic key_start, key_done, read_done, write_done;
    logic read_pending_q, start_sys, invalid_cfg;
    logic done_q, error_q;

    // ========================================================
    // 1. Verificação da configuração e lógica de início
    // ========================================================

    assign invalid_cfg = (num_blocks_q == 32'd0)  ||
                         (num_blocks_q > 32'd256) ||
                         (mode_q > 3'd5);

    assign key_start = (state_q == ST_CHECK) && !invalid_cfg;
    assign start_sys = aes_control[0]; // Pressupõe pulso no domínio de clk.

    // ========================================================
    // 2. Expansão de chave
    // ========================================================

    minisoc_aes_key_exp u_key_exp (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (key_start),
        .key       (key_q),
        .round     (round_q),
        .round_key (round_key),
        .done      (key_done)
    );

    // ========================================================
    // 3. Datapath AES
    // ========================================================

    minisoc_aes_dp u_dp (
        .clk          (clk),
        .rst_n        (rst_n),
        .fsm_state    (state_q),
        .block        (memory_block_q),
        .round        (round_q),
        .round_key    (round_key),
        .result_block (result_block)
    );

    // ========================================================
    // 4. FSM e execução de rodadas
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin : AES_FSM
        if (!rst_n) begin
            state_q       <= ST_IDLE;
            round_q       <= 4'd0;
            key_q         <= '0;
            num_blocks_q  <= '0;
            mode_q        <= '0;
            blocks_done_q <= '0;
            done_q        <= 1'b0;
            error_q       <= 1'b0;
        end else begin
            unique case (state_q)

                ST_IDLE: begin
                    if (start_sys) begin
                        done_q       <= 1'b0;
                        key_q        <= cfg_key;
                        num_blocks_q <= num_blocks;
                        mode_q       <= aes_control[4:2];
                        state_q      <= ST_CHECK;
                    end
                end

                ST_CHECK: begin
                    if (invalid_cfg) begin
                        error_q <= 1'b1;
                        state_q <= ST_ERROR;
                    end else begin
                        blocks_done_q <= '0;
                        state_q       <= ST_KEY_EXPANSION;
                    end
                end

                ST_KEY_EXPANSION: begin
                    if (key_done)
                        state_q <= ST_READ_BLOCK;
                    else
                        state_q <= ST_KEY_EXPANSION;
                end

                ST_READ_BLOCK: begin
                    if (read_done) begin
                        round_q <= 4'd0;
                        state_q <= ST_LOAD_STATE;
                    end else begin
                        state_q <= ST_READ_BLOCK;
                    end
                end

                ST_LOAD_STATE: begin
                    state_q <= ST_ADD_ROUND_KEY;
                end

                ST_ADD_ROUND_KEY: begin
                    if (round_q == 4'd10) begin
                        state_q <= ST_WRITE_BLOCK;
                    end else begin
                        round_q <= round_q + 4'd1;
                        state_q <= ST_SUB_BYTES;
                    end
                end

                ST_SUB_BYTES: begin
                    state_q <= ST_SHIFT_ROWS;
                end

                ST_SHIFT_ROWS: begin
                    if (round_q == 4'd10)
                        state_q <= ST_ADD_ROUND_KEY;
                    else
                        state_q <= ST_MIX_COLUMNS;
                end

                ST_MIX_COLUMNS: begin
                    state_q <= ST_ADD_ROUND_KEY;
                end

                ST_WRITE_BLOCK: begin
                    if (write_done) begin
                        blocks_done_q <= blocks_done_q + 9'd1;
                        state_q       <= ST_CHECK_BLOCKS;
                    end else begin
                        state_q <= ST_WRITE_BLOCK;
                    end
                end

                ST_CHECK_BLOCKS: begin
                    if (blocks_done_q == num_blocks_q)
                        state_q <= ST_DONE;
                    else
                        state_q <= ST_READ_BLOCK;
                end

                ST_DONE: begin
                    done_q  <= 1'b1;
                    state_q <= ST_IDLE;
                end

                ST_ERROR: state_q <= ST_IDLE;
                default:  state_q <= ST_IDLE;
            endcase
        end
    end

    // ========================================================
    // 5. Interface e controle de leitura/escrita da memória
    // ========================================================

    // block_q seleciona o bloco; word_q seleciona uma das 4 words.
    assign mem_addr  = {block_q[7:0], word_q};
    assign mem_we    = (state_q == ST_WRITE_BLOCK);
    assign mem_wdata = result_block[127 - 32*word_q -: 32]; // seleciona cada palavra de 32 bits para escrever
    
    // A lógica de atualização de word_q e block_q, assim como
    // a geração de read_done e write_done, será implementada
    // na Semana 6, dedicada ao controle de acesso à memória
    // e ao processamento de múltiplos blocos pelo AES Engine.

    // ========================================================
    // 6. Saída de status
    // ========================================================

    assign aes_status = {
        20'b0, // reservado
        blocks_done_q,  // [11:3]
        error_q,        // [2]
        done_q,         // [1]
        (state_q != ST_IDLE && state_q != ST_ERROR) // [0] BUSY
    };

endmodule