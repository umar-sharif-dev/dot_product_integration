module regn #(parameter N = 16) (
    input  logic clk,
    input  logic rst,
    input  logic en_reg,
    input  logic [N-1:0] d,
    output logic [N-1:0] q
);
    always_ff @(posedge clk) begin
        if (rst)
            q <= '0;
        else if (en_reg)
            q <= d;
    end
endmodule
