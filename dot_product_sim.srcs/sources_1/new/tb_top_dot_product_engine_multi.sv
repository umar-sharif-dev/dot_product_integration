`timescale 1ns / 1ps

module tb_top_dot_product_engine_multi;

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

  // Clock generation (200 MHz)
  always #2.5 clk = ~clk;

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

  int i, j;
  logic [31:0] results [0:63];

  // Task to preload x_vector[i] = 1.0
  task preload_bram;
    for (i = 0; i < 64; i++) begin
      @(posedge clk);
      x_wr_en   = 64'b1 << i;
      x_wr_data = 32'h3F800000; // FP32: 1.0
      x_wr_addr = 4'd0;
    end
    @(posedge clk);
    x_wr_en = 64'd0;
  endtask

  // Task to send 64 weight bytes (one row)
  task send_one_row(input int base_val);
    for (j = 0; j < 64; j++) begin
      @(posedge clk);
      en = 1;
      weight_byte = base_val + j; // unique row per dot product
    end
    @(posedge clk);
    // en = 0;
  endtask

  initial begin
    en = 0;
    start = 0;
    weight_byte = 0;
    x_wr_en = 0;
    x_wr_data = 0;
    x_wr_addr = 0;

    #20;
    rst = 0;
    rstn = 1;

    preload_bram();

    for (i = 0; i < 64; i++) begin
      send_one_row(i); // send A_row = {i, i+1, ..., i+63}
      @(posedge clk);
      start = 1;
      @(posedge clk);
      start = 0;
      wait(done);
      results[i] = y_out;
      $display("Dot product %0d result = %h", i, y_out);
      @(posedge clk);
    end

    #20;
    $finish;
  end

endmodule
