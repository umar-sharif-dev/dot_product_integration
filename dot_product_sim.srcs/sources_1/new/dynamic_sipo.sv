`timescale 1ns / 1ps
module dynamic_sipo #(
    parameter int WIDTH = 256  // Total output width
)(
    input  logic        clk,
    input  logic        rst,
    input  logic        en,
    input  logic [15:0] din,       // Raw input element (only lower bits used)
    input  logic [7:0]  shift,     // Number of bits per shift (2, 4, 8, 16)
    output logic [WIDTH-1:0] dout
);

    logic [WIDTH-1:0] shift_reg;
    logic [7:0]       counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= '0;
            counter   <= 0;
        end else if (en && (counter < WIDTH)) begin
            case (shift)
                8'd2: begin
                    shift_reg <= {shift_reg[WIDTH-3:0], din[1:0]};
                    counter   <= counter + 2;
                end
                8'd4: begin
                    shift_reg <= {shift_reg[WIDTH-5:0], din[3:0]};
                    counter   <= counter + 4;
                end
                8'd8: begin
                    shift_reg <= {shift_reg[WIDTH-9:0], din[7:0]};
                    counter   <= counter + 8;
                end
                8'd16: begin
                    shift_reg <= {shift_reg[WIDTH-17:0], din[15:0]};
                    counter   <= counter + 16;
                end
                default: begin
                    shift_reg <= shift_reg;
                    counter   <= counter;
                end
            endcase
        end
    end

    assign dout = shift_reg;

endmodule
