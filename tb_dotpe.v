// Testbench for Dot Product Engine with Controller

`timescale 1ns/1ps

module tb_dotpe;

    parameter N = 64;
    parameter CLK_PERIOD = 10;

    logic clk = 0;
    logic rst;
    logic start_op;
    logic start;
    logic en;
    logic busy;
    logic done;

    logic [8*N-1:0] A_row_packed;
    logic [31:0] x_vector [0:N-1];
    logic [31:0] y_out;

    logic done_pipeline;

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // DUT instantiation
    dot_product_engine #(.N(N)) dut (
        .clk(clk), .rst(rst), .start(start), .en(en),
        .A_row_packed(A_row_packed),
        .x_vector(x_vector),
        .y_out(y_out),
        .done(done_pipeline)
    );

    dotpe_controller ctrl (
        .clk(clk), .rst(rst), .start_op(start_op),
        .done_pipeline(done_pipeline),
        .start(start), .en(en), .busy(busy), .done(done)
    );

    // Golden model
    function real golden_dot_product(input byte A_int8 [0:N-1], input real x_fp32 [0:N-1]);
        real sum = 0.0;
        for (int i = 0; i < N; i++)
            sum += real'(A_int8[i]) * x_fp32[i];
        return sum;
    endfunction

    // Stimulus
    initial begin
        rst = 1;
        start_op = 0;
        #(2*CLK_PERIOD);
        rst = 0;

        // Generate random test vectors
        byte A_int8 [0:N-1];
        real x_fp32 [0:N-1];

        for (int i = 0; i < N; i++) begin
            A_int8[i] = $urandom_range(-128, 127);
            x_fp32[i] = $urandom_range(-1000, 1000) / 100.0;
            A_row_packed[i*8 +: 8] = A_int8[i];
            x_vector[i] = $bitstoreal(x_fp32[i]);
        end

        real expected = golden_dot_product(A_int8, x_fp32);
        $display("[TB] Golden dot product = %f", expected);

        // Trigger operation
        @(posedge clk);
        start_op = 1;
        @(posedge clk);
        start_op = 0;

        // Wait for done
        wait (done);
        $display("[TB] Output from DUT = %f", $bitstoreal(y_out));

        $finish;
    end

endmodule
