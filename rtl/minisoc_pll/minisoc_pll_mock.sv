module minisoc_pll_mock (
    input  logic       rst_n,
    input  logic       clk_in,      // Referência de 2 GHz.
    input  logic [1:0] pll_div_sel, // 00: /1, 01: /2, 10: /4, 11: /8.
    output logic       clk_out,
    output logic       o_locked
);
    logic clk_div2, clk_div4, clk_div8;

    assign o_locked = 1'b1;

    clock_divider #(.DIV_FACTOR(2)) u_div2 ( .clk_in(clk_in), .rst(rst_n), .clk_out(clk_div2) );

    clock_divider #(.DIV_FACTOR(4)) u_div4 ( .clk_in(clk_in), .rst(rst_n), .clk_out(clk_div4) );

    clock_divider #(.DIV_FACTOR(8)) u_div8 ( .clk_in(clk_in), .rst(rst_n), .clk_out(clk_div8) );

    always_comb begin
        case (pll_div_sel)
            2'b00: clk_out = clk_in;
            2'b01: clk_out = clk_div2;
            2'b10: clk_out = clk_div4;
            2'b11: clk_out = clk_div8;
            default: clk_out = 1'b0;
        endcase
    end
endmodule
