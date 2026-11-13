

module clock_divider #(parameter DIV_FACTOR = 20) (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

reg [$clog2(DIV_FACTOR)+1:0] counter;

always @(posedge clk_in or negedge rst) begin
    if (!rst) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        if (counter == (DIV_FACTOR / 2) - 1) begin
            clk_out <= ~clk_out;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
