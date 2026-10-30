
module minisoc_pll_mock
    import minisoc_pkg::*;
(
    input  logic       rst_n,
    input  logic       clk_in, // 2 GHz
    input  logic       pll_enable, // Quando 0, bloqueia clk_out e desativa o_locked.
    input  logic [1:0] pll_div_sel, // Seleciona um dos quatro divisores da seção 4.1.
    output logic       clk_out,
    output logic       o_locked
);

endmodule
