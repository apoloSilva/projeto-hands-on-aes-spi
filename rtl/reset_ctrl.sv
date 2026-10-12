
module reset_ctrl (
    input  logic clk_sys,
    input  logic sclk,
    input  logic global_rst_n,
    input  logic pll_locked,
    output logic rst_sys_n,
    output logic rst_pll_n
);
	
    assign rst_pll_n  = global_rst_n;
    assign rst_sys_n  = global_rst_n;

endmodule
