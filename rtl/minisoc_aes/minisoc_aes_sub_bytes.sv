
 // Executa SubBytes() ou InvSubBytes() combinacionalmente.
 // Utiliza 16 instâncias da S-box para processar os 16 bytes em paralelo.

module minisoc_aes_sub_bytes (
    input  logic sel_mode, // 0 para SUBBYTES() e 1 para INVSUBBYTES()

    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    // Uma instância da S-box para cada byte do State.
    for (genvar i = 0; i < 16; i++) begin : gen_sub_bytes

        minisoc_aes_sbox u_minisoc_aes_sbox (
            .byte_in  (state_in [127 - 8*i -: 8]), // atribuí os bytes de i = 0 (127:120) até i = 15 (7:0)
            .byte_out (state_out[127 - 8*i -: 8]), // para cada S-Box
            .sel_mode (sel_mode)
        );

    end

endmodule