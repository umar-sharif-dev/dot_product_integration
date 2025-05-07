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

  int i;
  logic [31:0] results [0:63];

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

    // Fill initial 64 bytes to complete first A_row
    for (i = 0; i < 64; i++) begin
      @(posedge clk);
      en = 1;
      weight_byte = i[7:0];
    end

    // Generate 64 outputs: each new 512-bit row slides by 1 byte
    for (i = 64; i < 128; i++) begin
      @(posedge clk);
      weight_byte = i[7:0];  // push next byte into SIPO
      en = 1;
      start = 1;
      @(posedge clk);
      start = 0;
      wait(done);
      results[i-64] = y_out;
      $display("Dot product %0d = %h", i-64, y_out);
    end

    @(posedge clk);
    en = 0;
    #20;
    $finish;
  end

endmodule
