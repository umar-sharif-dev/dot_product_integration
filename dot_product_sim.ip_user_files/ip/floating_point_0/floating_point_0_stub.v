// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Wed May 28 22:54:21 2025
// Host        : NB10535 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/MalikUmarSharif/Downloads/dot_product_sim_may28.xpr/dot_product_sim/dot_product_sim.gen/sources_1/ip/floating_point_0/floating_point_0_stub.v
// Design      : floating_point_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku5p-ffvb676-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "floating_point_v7_1_18,Vivado 2024.1" *)
module floating_point_0(aclk, aresetn, s_axis_a_tvalid, 
  s_axis_a_tready, s_axis_a_tdata, m_axis_result_tvalid, m_axis_result_tready, 
  m_axis_result_tdata)
/* synthesis syn_black_box black_box_pad_pin="aresetn,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[31:0],m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[31:0]" */
/* synthesis syn_force_seq_prim="aclk" */;
  input aclk /* synthesis syn_isclock = 1 */;
  input aresetn;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [31:0]m_axis_result_tdata;
endmodule
