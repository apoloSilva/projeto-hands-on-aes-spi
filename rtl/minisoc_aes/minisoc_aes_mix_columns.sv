module minisoc_aes_mix_columns (
    input  logic         sel_mode, // 0: MixColumns; 1: InvMixColumns
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    // Função auxiliar de multiplicação
    function automatic logic [7:0] byte_mul (
        input logic [7:0] a,
        input logic [7:0] b
    );
        logic [7:0] product;
        logic [7:0] factor;

        product = 8'h00;
        factor  = a;

        for (int i = 0; i < 8; i++) begin
            if (b[i])
                product = product ^ factor;

            factor = {factor[6:0], 1'b0} ^
                     (factor[7] ? 8'h1b : 8'h00);
        end

        return product;
    endfunction

    // Aplica a matriz direta ou inversa a uma coluna de quatro bytes.
    function automatic logic [31:0] transform_column (
        input logic [31:0] column,
        input logic        inverse
    );
        logic [7:0] b0, b1, b2, b3;

        b0 = column[31:24];
        b1 = column[23:16];
        b2 = column[15:8];
        b3 = column[7:0];

        if (!inverse) begin
            transform_column = { // MixColumns: equações (5.8) da FIPS 197
                byte_mul(b0, 8'h02) ^ byte_mul(b1, 8'h03) ^ b2 ^ b3,
                b0 ^ byte_mul(b1, 8'h02) ^ byte_mul(b2, 8'h03) ^ b3,
                b0 ^ b1 ^ byte_mul(b2, 8'h02) ^ byte_mul(b3, 8'h03),
                byte_mul(b0, 8'h03) ^ b1 ^ b2 ^ byte_mul(b3, 8'h02)
            };
        end else begin
            transform_column = { // InvMixColumns: equações (5.15) da FIPS 197
                byte_mul(b0, 8'h0e) ^ byte_mul(b1, 8'h0b) ^
                byte_mul(b2, 8'h0d) ^ byte_mul(b3, 8'h09),

                byte_mul(b0, 8'h09) ^ byte_mul(b1, 8'h0e) ^
                byte_mul(b2, 8'h0b) ^ byte_mul(b3, 8'h0d),

                byte_mul(b0, 8'h0d) ^ byte_mul(b1, 8'h09) ^
                byte_mul(b2, 8'h0e) ^ byte_mul(b3, 8'h0b),

                byte_mul(b0, 8'h0b) ^ byte_mul(b1, 8'h0d) ^
                byte_mul(b2, 8'h09) ^ byte_mul(b3, 8'h0e)
            };
        end
    endfunction

    // As quatro colunas são transformadas em paralelo.
    for (genvar c = 0; c < 4; c++) begin : g_column
        assign state_out[127 - 32*c -: 32] = transform_column(state_in[127 - 32*c -: 32], sel_mode);
    end

endmodule