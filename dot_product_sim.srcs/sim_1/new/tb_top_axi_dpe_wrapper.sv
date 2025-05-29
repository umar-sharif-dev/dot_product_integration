`timescale 1ns/1ps

module tb_top_axi_dpe_wrapper;

  // Clock and Reset
  logic clk;
  logic rst;
  logic rstn;

  // BRAM preload interface
  logic [3:0]   x_wr_addr;
  logic [31:0]  x_wr_data;
  logic [63:0]  x_wr_en;

  // AXI-Lite
  logic         s_axi_awvalid = 0;
  logic         s_axi_awready;
  logic [4:0]   s_axi_awaddr = 0;
  logic [2:0]   s_axi_awprot = 0;
  logic         s_axi_wvalid = 0;
  logic         s_axi_wready;
  logic [31:0]  s_axi_wdata = 0;
  logic [3:0]   s_axi_wstrb = 0;
  logic         s_axi_bvalid;
  logic         s_axi_bready = 0;
  logic [1:0]   s_axi_bresp;
  logic         s_axi_arvalid = 0;
  logic         s_axi_arready;
  logic [4:0]   s_axi_araddr;
  logic [2:0]   s_axi_arprot;
  logic         s_axi_rvalid;
  logic         s_axi_rready;
  logic [31:0]  s_axi_rdata;
  logic [1:0]   s_axi_rresp;

  // AXI Master
  logic         m_axi_arvalid;
  logic         m_axi_arready = 0;
  logic [31:0]  m_axi_araddr;
  logic [7:0]   m_axi_arlen;
  logic [2:0]   m_axi_arsize;
  logic [1:0]   m_axi_arburst;
  logic [2:0]   m_axi_arprot;
  logic [3:0]   m_axi_arcache;
  logic         m_axi_rvalid = 0;
  logic         m_axi_rready;
  logic [255:0] m_axi_rdata;
  logic [1:0]   m_axi_rresp;
  logic         m_axi_rlast;
  logic         m_axi_awvalid;
  logic         m_axi_awready;
  logic [31:0]  m_axi_awaddr;
  logic [7:0]   m_axi_awlen;
  logic [2:0]   m_axi_awsize;
  logic [1:0]   m_axi_awburst;
  logic [2:0]   m_axi_awprot;
  logic [3:0]   m_axi_awcache;
  logic         m_axi_wvalid;
  logic         m_axi_wready;
  logic [255:0] m_axi_wdata;
  logic [31:0]  m_axi_wstrb;
  logic         m_axi_wlast;
  logic         m_axi_bvalid;
  logic         m_axi_bready;
  logic [1:0]   m_axi_bresp;
  
  logic [31:0]  dma_source_addr;
  logic [31:0]  dma_target_addr;
  logic [31:0]  dma_length;      
  logic         dma_start = 0;
  
  logic [2:0]   dpe_data_type;

  // Parameters
  parameter NUM_WORDS = 1;

  // Clock generator
  initial clk = 0;
  always #5 clk = ~clk;

  // DUT instance
  top_axi_dpe_wrapper dut (
    .clk(clk),
    .rst(rst),
    .rstn(rstn),
    .x_wr_addr(x_wr_addr),
    .x_wr_data(x_wr_data),
    .x_wr_en(x_wr_en),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arprot(m_axi_arprot),
    .m_axi_arcache(m_axi_arcache),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_awprot(m_axi_awprot),
    .m_axi_awcache(m_axi_awcache),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready),
    .m_axi_bresp(m_axi_bresp),
    
    .dma_source_addr(dma_source_addr),
    .dma_target_addr(dma_target_addr),
    .dma_length(dma_length),
    .dma_start(dma_start),
    
    .dpe_data_type(dpe_data_type)
  );

    // Pre-computed m_axi_rdata values with zero-padded left shifts of {0x00, ..., 0x1F}
    logic [255:0] m_axi_rdata_sequence [0:30];

    initial begin
        m_axi_rdata_sequence[ 0] = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
        m_axi_rdata_sequence[ 1] = 256'h0102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F00;
        m_axi_rdata_sequence[ 2] = 256'h02030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F0000;
        m_axi_rdata_sequence[ 3] = 256'h030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F000000;
        m_axi_rdata_sequence[ 4] = 256'h0405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F00000000;
        m_axi_rdata_sequence[ 5] = 256'h05060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F0000000000;
        m_axi_rdata_sequence[ 6] = 256'h060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F000000000000;
        m_axi_rdata_sequence[ 7] = 256'h0708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F00000000000000;
        m_axi_rdata_sequence[ 8] = 256'h08090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F0000000000000000;
        m_axi_rdata_sequence[ 9] = 256'h090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F000000000000000000;
        m_axi_rdata_sequence[10] = 256'h0A0B0C0D0E0F101112131415161718191A1B1C1D1E1F00000000000000000000;
        m_axi_rdata_sequence[11] = 256'h0B0C0D0E0F101112131415161718191A1B1C1D1E1F0000000000000000000000;
        m_axi_rdata_sequence[12] = 256'h0C0D0E0F101112131415161718191A1B1C1D1E1F000000000000000000000000;
        m_axi_rdata_sequence[13] = 256'h0D0E0F101112131415161718191A1B1C1D1E1F00000000000000000000000000;
        m_axi_rdata_sequence[14] = 256'h0E0F101112131415161718191A1B1C1D1E1F0000000000000000000000000000;
        m_axi_rdata_sequence[15] = 256'h0F101112131415161718191A1B1C1D1E1F000000000000000000000000000000;
        m_axi_rdata_sequence[16] = 256'h101112131415161718191A1B1C1D1E1F00000000000000000000000000000000;
        m_axi_rdata_sequence[17] = 256'h1112131415161718191A1B1C1D1E1F0000000000000000000000000000000000;
        m_axi_rdata_sequence[18] = 256'h12131415161718191A1B1C1D1E1F000000000000000000000000000000000000;
        m_axi_rdata_sequence[19] = 256'h131415161718191A1B1C1D1E1F00000000000000000000000000000000000000;
        m_axi_rdata_sequence[20] = 256'h1415161718191A1B1C1D1E1F0000000000000000000000000000000000000000;
        m_axi_rdata_sequence[21] = 256'h15161718191A1B1C1D1E1F000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[22] = 256'h161718191A1B1C1D1E1F00000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[23] = 256'h1718191A1B1C1D1E1F0000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[24] = 256'h18191A1B1C1D1E1F000000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[25] = 256'h191A1B1C1D1E1F00000000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[26] = 256'h1A1B1C1D1E1F0000000000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[27] = 256'h1B1C1D1E1F000000000000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[28] = 256'h1C1D1E1F00000000000000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[29] = 256'h1D1E1F0000000000000000000000000000000000000000000000000000000000;
        m_axi_rdata_sequence[30] = 256'h1E1F000000000000000000000000000000000000000000000000000000000000;
    end


  // Reset sequence
  initial begin
    rst  = 1;
    rstn = 0;
    #20;
    rst  = 0;
    rstn = 1;
  end

  logic [6:0] j = 0;

  // Stimulus process
  initial begin
    // Preload x_vector with 1.0 FP32
    for (int i = 0; i < 32; i++) begin
      @(posedge clk);
      x_wr_en   = 64'b1 << i;
      x_wr_data = 32'h3F800000; // FP32: 1.0
      x_wr_addr = 4'd0;
    end
    x_wr_en = 64'd0;

    #20;
    // Setup AXI-Lite registers
    assign dma_source_addr = 32'h00000000; // REG_SOURCE_ADDR
    #100;
    assign dma_target_addr = 32'h00000100; // REG_TARGET_ADDR
    #100;
    assign dma_length = NUM_WORDS * 32; // REG_LENGTH
    #100;
    assign dpe_data_type = 3; // REG_DPE_DATA_TYPE (int8)
    #100;
    
    // Set dma_start to 1 on posedge of clk
    @(posedge clk);
     dma_start = 1; // REG_CONTROL (start)
    #100;
    dma_start = 0; // REG_CONTROL (start)
    
    for (j = 0; j <= NUM_WORDS; j++) begin    
      @(posedge clk);
      m_axi_rvalid = 1;
//      m_axi_rdata  = m_axi_rdata_sequence[j];
      m_axi_rdata  = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
      m_axi_rlast  = (j == NUM_WORDS-1);
      
      // Wait for slave to accept the data
      wait (m_axi_rready);
      m_axi_arready = 1;
      @(posedge clk);
      @(posedge clk);
    end
      // Deassert after handshake
      m_axi_rvalid = 0;
      m_axi_rlast  = 0;

    // Wait for DMA completion
    repeat (1000) @(posedge clk);
    $finish;
  end

endmodule
