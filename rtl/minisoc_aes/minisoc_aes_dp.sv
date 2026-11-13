// FIPS 197-upd1: Algoritmo 1 (CIPHER) e Algoritmo 3 (INVCIPHER).
module minisoc_aes_dp
    import minisoc_pkg::*;
(
    input  logic         clk,
    input  logic         rst_n,
    input  logic         sel_mode,    // 0: CIPHER; 1: INVCIPHER.
    input  state_t       fsm_state,
    input  logic [127:0] block,
    input  logic [3:0]   round,
    input  logic [127:0] round_key,   // w[4*round..4*round+3], do key_exp via top.
    output logic [127:0] result_block
);

    // FIPS 197, seção 3.4: s[r,c] ocupa o byte r + 4*c, contado do MSB.
    logic [127:0] aes_state_q;
    logic [127:0] add_round_key_out, sub_bytes_out;
    logic [127:0] shift_rows_out, mix_columns_out;

    minisoc_aes_add_round_key u_add_round_key (.state_in  (aes_state_q),.round_key (round_key),.state_out (add_round_key_out));

    minisoc_aes_sub_bytes #(.BLOCK_WIDTH(16)) u_sub_bytes ( .sel_mode(sel_mode), .state_in(aes_state_q), .state_out(sub_bytes_out));

    minisoc_aes_shift_rows u_shift_rows (.sel_mode(sel_mode),.state_in(aes_state_q),.state_out(shift_rows_out));

    minisoc_aes_mix_columns u_mix_columns (.sel_mode(sel_mode),.state_in(aes_state_q),.state_out(mix_columns_out));

    // A FSM do top define a ordem. Cada borda registra uma etapa do pseudocódigo.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aes_state_q <= '0;
        end else begin
            case (fsm_state)
                // Algoritmos 1 e 3, linha 2: state recebe o bloco de entrada.
                ST_LOAD_STATE: aes_state_q <= block;

                // Alg. 1, linhas 3, 8 e 12 (K0 a K10).
                // Alg. 3, linhas 3, 7 e 12 (K10 a K0).
                ST_ADD_ROUND_KEY: aes_state_q <= add_round_key_out;

                // Alg. 1, linhas 5 e 10. Alg. 3, linhas 6 e 11 (inversa).
                ST_SUB_BYTES: aes_state_q <= sub_bytes_out;

                // Alg. 1, linhas 6 e 11. Alg. 3, linhas 5 e 10 (inversa).
                ST_SHIFT_ROWS: aes_state_q <= shift_rows_out;

                // Alg. 1, linha 7: antes de AddRoundKey.
                // Alg. 3, linha 8: InvMixColumns após AddRoundKey.
                ST_MIX_COLUMNS: begin
                    if ((round > 4'd0) && (round < 4'd10))
                        aes_state_q <= mix_columns_out;
                end

                default: begin end  // Mantém o estado durante a escrita e a espera.
            endcase
        end
    end

    // Algoritmos 1 e 3, linha 13: resultado estável durante ST_WRITE_BLOCK.
    assign result_block = aes_state_q;
endmodule
