`timescale 1ns / 1ps

module tb_top_dot_product_engine;

  // Clock and reset
  logic clk = 0;
  logic rst = 1;
  logic rstn = 0;

  // DUT inputs
  logic en;
  logic start;
  logic [7:0]  weight_byte;
  logic [3:0]  x_wr_addr;
  logic [31:0] x_wr_data;
  logic [63:0] x_wr_en;

  // DUT outputs
  logic [31:0] y_out;
  logic done;

  // Clock generation: 200 MHz
  always #2.5 clk = ~clk;

  // Instantiate DUT
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

  // Task: Send 64 x 512-bit deterministic weight blocks
  task send_weights;
    int i, j;
    for (i = 0; i < 64; i++) begin
      for (j = 0; j < 64; j++) begin
        @(posedge clk);
        en = 1;
        weight_byte = j;  // A_row = {0,1,2,...63}
      end
    end
    @(posedge clk);
    en = 0;
  endtask

  // Task: Preload BRAMs with x_vector[i] = 1.0 (FP32 = 0x3F800000)
  task preload_bram;
    int i;
    for (i = 0; i < 64; i++) begin
      @(posedge clk);
      x_wr_en = 64'b1 << i;
      x_wr_data = 32'h3F800000; // FP32 value of 1.0
      x_wr_addr = 4'd0;
    end
    @(posedge clk);
    x_wr_en = 64'd0;
  endtask

  initial begin
    // Reset
    en = 0;
    start = 0;
    weight_byte = 0;
    x_wr_en = 0;
    x_wr_data = 0;
    x_wr_addr = 0;

    #20;
    rst = 0;
    rstn = 1;

    // Preload BRAMs and weights
    preload_bram();
    send_weights();

    // Start dot product
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    // Wait for done
    wait (done == 1);

    $display("Dot product result (expected = 0+1+2+...+63 = 2016.0): %h", y_out);
    #20;
    $finish;
  end

endmodule
