//=====================================================================
// tb_dot_product_engine_fp.sv
// --------------------------------------------------------------------
// Minimal functional testbench for the FP version
//=====================================================================
`timescale 1ns/1ps
module tb_dot_product_engine_fp;

    localparam int N = 64;

    // DUT I/O
    logic                    clk   = 0;
    logic                    rstn  = 1'b0;     // active-low
    logic                    start = 1'b0;
    logic [8*N-1:0]          A_row_packed;
    logic [31:0]             x_vector [0:N-1];
    logic [31:0]             y_out;
    logic                    done;

    // 100 MHz clock
    always #5ns clk = ~clk;

    //-------------------------------------------------------------
    // Instantiate DUT
    //-------------------------------------------------------------
    dot_product_engine #(.N(N)) dut (
        .clk          (clk),
        .rstn         (rstn),
        .start        (start),
        .A_row_packed (A_row_packed),
        .x_vector     (x_vector),
        .y_out        (y_out),
        .done         (done)
    );

    //-------------------------------------------------------------
    // Stimulus
    //-------------------------------------------------------------
    initial begin : TB
        int i;

        // 1) Release reset after a few cycles
        repeat (4) @(posedge clk);
        rstn <= 1'b1;                    // de-assert reset
        @(posedge clk);

        // 2) Fixed data (weights 1..64, all x = 1.0)
        for (i = 0; i < N; i++) begin
            A_row_packed[i*8 +: 8] = i + 1;
//            x_vector[i]            = 32'h3F800000; // 1.0f
            x_vector[i]            = 32'h4080_0000; // 4.0f
        end

        // 3) Single-cycle START
        @(posedge clk);
        start <= 1'b1;
        @(posedge clk);
        start <= 1'b0;

        // 4) Wait for DONE then print
        wait (done);
        $display("-----------------------------------------");
        $display("DOT PRODUCT (hex) : %h", y_out);
        $display("DOT PRODUCT (real): %f", $bitstoshortreal(y_out));
        $display("-----------------------------------------");
        #20 $finish;
    end
endmodule
