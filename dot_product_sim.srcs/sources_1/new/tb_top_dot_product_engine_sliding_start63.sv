`timescale 1ns / 1ps

module tb_top_dot_product_engine_sliding;

  logic clk = 0;
  logic rst = 1;
  logic rstn = 0;

  logic en;
  logic start;
  logic [7:0]  weight_byte;
  logic [3:0]  x_wr_addr;
  logic [31:0] x_wr_data;
  logic [63:0] x_wr_en;

  logic [31:0] y_out;
  logic done;

  always #2.5 clk = ~clk;  // 200 MHz clock

  top_dot_product_engine dut (
    .clk(clk),
    .rst(rst),
    .rstn(rstn),
    .en(en),
    .start(start),
    .weight_byte(weight_byte),
    .x_wr_addr(x_wr_addr),
    .x_wr_data(x_wr_data),
    .x_wr_en(x_wr_en),
    .y_out(y_out),
    .done(done)
  );

  int j, output_index;
  logic [31:0] results [0:63];

  task preload_bram;
    for (int i = 0; i < 64; i++) begin
      @(posedge clk);
      x_wr_en   = 64'b1 << i;
      x_wr_data = 32'h3F800000; // FP32: 1.0
      x_wr_addr = 4'd0;
    end
    @(posedge clk);
    x_wr_en = 64'd0;
  endtask

  initial begin
    en = 0;
    start = 0;
    weight_byte = 0;
    x_wr_en = 0;
    x_wr_data = 0;
    x_wr_addr = 0;
    output_index = 0;

    #20;
    rst = 0;
    rstn = 1;

    preload_bram();

    // Stream in 128 bytes, assert start once enough (64) are available
    for (j = 0; j < 128; j++) begin
      @(posedge clk);
      en = 1;
      weight_byte = j[7:0];

      // Start dot product when 64 bytes are collected (and then on every clock)
      if (j >= 63) begin
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done);
        results[output_index] = y_out;
        $display("Dot product %0d = %h", output_index, y_out);
        output_index++;
      end
    end

    @(posedge clk);
    en = 0;
    #20;
    $finish;
  end

endmodule
