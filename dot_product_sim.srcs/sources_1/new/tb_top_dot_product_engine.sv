`timescale 1ns / 1ps

module tb_top_dot_product_engine_multi;

  logic clk = 0;
  logic rst = 1;
  logic rstn = 0;

  logic en = 1;
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

  initial begin
    start = 0;
    weight_byte = 0;
    x_wr_en = 0;
    x_wr_data = 0;
    x_wr_addr = 0;

    #20;
    rst = 0;
    rstn = 1;

    preload_bram();

    for (j = 0; j < 128; j++) begin
        weight_byte = j; // unique row per dot product
        @(posedge clk);
        
        if (j >= 63) begin
            start = 1;
        end
    end  
    
    wait(done);
    results[i] = y_out;
    $display("Dot product %0d result = %h", i, y_out);

    #20;
    $finish;
  end

endmodule
