
module minisoc_top_tb;

    import semana02_test_vectors_pkg::*;

    logic sel_mode;
    logic [127:0] state_in, sub_in, sub_out, shift_in, shift_out;

    // Instanciação dos DUTs.
    minisoc_aes_sub_bytes u_sub_bytes(.sel_mode (sel_mode),.state_in(sub_in),.state_out (sub_out));

    minisoc_aes_shift_rows u_shift_rows (.sel_mode(sel_mode),.state_in(shift_in),.state_out(shift_out));

    // Seleciona o encadeamento das transformações.
    assign sub_in   = sel_mode ? shift_out : state_in;
    assign shift_in = sel_mode ? state_in  : sub_out;

    // Execução dos testes.
    initial begin
    //    $fsdbDumpfile("waves.fsdb");
    //    $fsdbDumpvars(0, minisoc_aes_tb);

        $display("\nTESTANDO: SUBBYTES() e SHIFTROWS()");
        check_cypher_round(1, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(2, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(3, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(4, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(5, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(6, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(7, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(8, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(9, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_cypher_round(10, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);

        $display("\nTESTANDO: INVSHIFTROWS() e INVSUBBYTES()");
        check_inv_cypher_round(1, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(2, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(3, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(4, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(5, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(6, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(7, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(8, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);
        check_inv_cypher_round(9, state_start_of_round_1, after_subbytes_of_round_1, after_shiftrows_of_round_1);

        $display("\n");

        $finish;
    end

    // Rotinas de verificação.
    task automatic check_cypher_round (
        input int round_num,
        input logic [127:0] state_start,
        input logic [127:0] expected_sub,
        input logic [127:0] expected_shift
    );
        sel_mode = 1'b0;
        state_in = state_start;
        #1;

        if (sub_out !== expected_sub)
            $fatal(1, "FAIL SubBytes Round %0d", round_num);

        if (shift_out !== expected_shift)
            $fatal(1, "FAIL ShiftRows Round %0d", round_num);

        $display("PASS CIPHER Round %0d", round_num);
    endtask

    task automatic check_inv_cypher_round (
        input int round_num,
        input logic [127:0] state_start,
        input logic [127:0] expected_sub,
        input logic [127:0] expected_shift
    );
        sel_mode = 1'b1;
        state_in = expected_shift;
        #1;

        if (shift_out !== expected_sub)
            $fatal(1, "FAIL InvShiftRows Round %0d", round_num);

        if (sub_out !== state_start)
            $fatal(1, "FAIL InvSubBytes Round %0d", round_num);

        $display("PASS INVCIPHER Round %0d", round_num);
    endtask

endmodule
