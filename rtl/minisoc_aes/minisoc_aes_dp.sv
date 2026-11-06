module minisoc_aes_dp
    import minisoc_pkg::*;
(
    input  logic         clk,
    input  logic         rst_n,
    input  state_t       fsm_state,
    input  logic [127:0] block,
    input  logic         round,
    input  logic [127:0] round_key,
    output logic [127:0] result_block
);
 

endmodule