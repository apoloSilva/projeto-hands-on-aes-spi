
module minisoc_memory
    import minisoc_pkg::*;
(
    input  logic                      clk,
    input  logic                      wr_en,
    input  logic [MEM_ADDR_WIDTH-1:0] addr,
    input  logic [MEM_DATA_WIDTH-1:0] wdata,
    output logic [MEM_DATA_WIDTH-1:0] rdata
);

endmodule
