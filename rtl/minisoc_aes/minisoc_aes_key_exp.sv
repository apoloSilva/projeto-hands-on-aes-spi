
 // Baseado no Algorithm 2 Pseudocode for KEYEXPANSION() da FIPS-197

module minisoc_aes_key_exp (
    input  logic         clk, rst_n,
    input  logic         start_exp,
    input  logic [127:0] key_start, // cipher key
    input  logic [3:0]   round_q,
    output logic [127:0] round_key,
    output logic         key_done
);

    localparam int Nk = 4;  // AES-128 - a chave original possui 4 palavras de 32 bits.
    localparam int Nr = 10; // AES-128 - o AES-128 possui 10 rodadas.

    logic [31:0] w [0:4*(Nr+1)-1];

    logic [5:0] i_q;
    logic       expanding_q;

    wire [31:0] sub_in, sub_out;

    // SUBWORD(): substituição dos quatro bytes pela S-box.
    minisoc_aes_sub_bytes #(.BLOCK_WIDTH(4)) subword ( .sel_mode(1'b0), .state_in(sub_in), .state_out(sub_out));

    // Acesso a 1 de 10 rounds constants.
    function automatic logic [31:0] rcon(input logic [3:0] j);
        case (j)
            4'd1:    rcon = 32'h01000000;
            4'd2:    rcon = 32'h02000000;
            4'd3:    rcon = 32'h04000000;
            4'd4:    rcon = 32'h08000000;
            4'd5:    rcon = 32'h10000000;
            4'd6:    rcon = 32'h20000000;
            4'd7:    rcon = 32'h40000000;
            4'd8:    rcon = 32'h80000000;
            4'd9:    rcon = 32'h1B000000;
            4'd10:   rcon = 32'h36000000;
            default: rcon = 32'h00000000;
        endcase
    endfunction

    // ROTWORD(): deslocamento circular de um byte para a esquerda.
    function automatic logic [31:0] rotword(input logic [31:0] word_in);
        rotword = {word_in[23:0], word_in[31:24]};
    endfunction

    // SUBWORD(ROTWORD(w[i-1])).
    assign sub_in = rotword(w[i_q-1]);

    // Copiar a chave original e expandir as demais 40 palavras.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_q         <= Nk;
            expanding_q <= 1'b0;
            key_done    <= 1'b0;

            for (int i = 0; i < 4*(Nr+1); i++) // avaliar a remoção dessa parte em estágios avançados
                w[i] <= 32'b0;

        end else if (start_exp) begin
            // Copiar a chave original para w[i] (combinacional).
            for (int i = 0; i < Nk; i++)
                w[i] <= key_start[127 - 32*i -: 32];

            i_q         <= Nk;
            expanding_q <= 1'b1;
            key_done    <= 1'b0;

        end else if (expanding_q) begin

            if (i_q % Nk == 0) begin
                w[i_q] <= w[i_q-Nk] ^ sub_out ^ rcon(4'(i_q/Nk));
            end else begin
                w[i_q] <= w[i_q-Nk] ^ w[i_q-1];
            end

            if (i_q == 4*(Nr+1)-1) begin
                expanding_q <= 1'b0;
                key_done    <= 1'b1;
            end

            i_q <= i_q + 1'b1;
        end
    end

    // Selecionar a chave correspondente à rodada (K0 até K10).
    assign round_key = (round_q <= Nr) ? {w[4*round_q], w[4*round_q+1], w[4*round_q+2], w[4*round_q+3]} : 128'b0;

endmodule
