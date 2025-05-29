`timescale 1ns/1ps

module top_axi_dpe_wrapper (
    input  logic         clk,
    input  logic         rst,
    input  logic         rstn,

    // BRAM preload interface
    input  logic [3:0]   x_wr_addr,
    input  logic [31:0]  x_wr_data,
    input  logic [63:0]  x_wr_en,

    // AXI-Lite
    input  logic         s_axi_awvalid,
    output logic         s_axi_awready,
    input  logic [4:0]   s_axi_awaddr,
    input  logic [2:0]   s_axi_awprot,
    input  logic         s_axi_wvalid,
    output logic         s_axi_wready,
    input  logic [31:0]  s_axi_wdata,
    input  logic [3:0]   s_axi_wstrb,
    output logic         s_axi_bvalid,
    input  logic         s_axi_bready,
    output logic [1:0]   s_axi_bresp,
    input  logic         s_axi_arvalid,
    output logic         s_axi_arready,
    input  logic [4:0]   s_axi_araddr,
    input  logic [2:0]   s_axi_arprot,
    output logic         s_axi_rvalid,
    input  logic         s_axi_rready,
    output logic [31:0]  s_axi_rdata,
    output logic [1:0]   s_axi_rresp,

    // AXI Master
    output logic         m_axi_arvalid,
    input  logic         m_axi_arready,
    output logic [31:0]  m_axi_araddr,
    output logic [7:0]   m_axi_arlen,
    output logic [2:0]   m_axi_arsize,
    output logic [1:0]   m_axi_arburst,
    output logic [2:0]   m_axi_arprot,
    output logic [3:0]   m_axi_arcache,
    input  logic         m_axi_rvalid,
    output logic         m_axi_rready,
    input  logic [255:0] m_axi_rdata,
    input  logic [1:0]   m_axi_rresp,
    input  logic         m_axi_rlast,
    output logic         m_axi_awvalid,
    input  logic         m_axi_awready,
    output logic [31:0]  m_axi_awaddr,
    output logic [7:0]   m_axi_awlen,
    output logic [2:0]   m_axi_awsize,
    output logic [1:0]   m_axi_awburst,
    output logic [2:0]   m_axi_awprot,
    output logic [3:0]   m_axi_awcache,
    output logic         m_axi_wvalid,
    input  logic         m_axi_wready,
    output logic [255:0] m_axi_wdata,
    output logic [31:0]  m_axi_wstrb,
    output logic         m_axi_wlast,
    input  logic         m_axi_bvalid,
    output logic         m_axi_bready,
    input  logic [1:0]   m_axi_bresp,
    
    input logic [31:0]  dma_source_addr,
    input logic [31:0]  dma_target_addr,
    input logic [31:0]  dma_length,      
    input logic         dma_start,
    
    input logic [2:0]   dpe_data_type
);

    logic         dpe_start;
    logic         dpe_valid;
    logic [255:0] dpe_data;
//    logic [2:0]   dpe_data_type;
    logic [31:0]  y_out;
    logic         done;

    axi_memset_dma #(
        .C_S_AXI_ADDR_WIDTH(5),
        .C_S_AXI_DATA_WIDTH(32),
        .C_M_AXI_ADDR_WIDTH(32),
        .C_M_AXI_DATA_WIDTH(256),
        .C_M_AXI_BURST_LEN(16)
    ) dma_inst (
        .aclk(clk),
        .aresetn(rstn),
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
        
        .dpe_start(dpe_start),
        .dpe_valid(dpe_valid),
        .dpe_data(dpe_data),
//        .dpe_data_type(dpe_data_type),
        .dpe_result(y_out),
        .dpe_done(done)
    );


    top_dot_product_engine dpe_top_inst (
        .clk         (clk),
        .rst         (rst),
        .rstn        (rstn),
        .start       (dpe_start),
        .data_type   (dpe_data_type),
        .A_valid     (dpe_valid),
        .A_data      (dpe_data),
        .x_wr_addr   (x_wr_addr),
        .x_wr_data   (x_wr_data),
        .x_wr_en     (x_wr_en),
        .y_out       (y_out),
        .done        (done)
    );

endmodule
