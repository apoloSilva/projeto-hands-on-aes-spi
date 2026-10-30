// Executa ShiftRows() ou InvShiftRows() combinacionalmente.
// Reordena os 16 bytes do State por deslocamento circular das linhas.

module minisoc_aes_shift_rows (
    input  logic sel_mode, // 0 para SHIFTROWS() e 1 para INVSHIFTROWS()

    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    // Reordena os bytes de cada linha.
    for (genvar r = 0; r < 4; r++) begin : gen_row
        for (genvar c = 0; c < 4; c++) begin : gen_col

            localparam int OUT_IDX = 4*c + r;
            localparam int SHIFT_IDX = 4*((c+r)%4) + r;
            localparam int INV_IDX = 4*((c+4-r)%4) + r;

            assign state_out[127 - 8*OUT_IDX -: 8] = sel_mode ?
                   state_in[127 - 8*INV_IDX -: 8] :
                   state_in[127 - 8*SHIFT_IDX -: 8];

        end
    end

endmodule