// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Wed May 28 22:53:22 2025
// Host        : NB10535 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/MalikUmarSharif/Downloads/dot_product_sim_may28.xpr/dot_product_sim/dot_product_sim.gen/sources_1/ip/floating_point_3/floating_point_3_sim_netlist.v
// Design      : floating_point_3
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku5p-ffvb676-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "floating_point_3,floating_point_v7_1_18,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "floating_point_v7_1_18,Vivado 2024.1" *) 
(* NotValidForBitStream *)
module floating_point_3
   (aclk,
    aresetn,
    s_axis_a_tvalid,
    s_axis_a_tready,
    s_axis_a_tdata,
    m_axis_result_tvalid,
    m_axis_result_tready,
    m_axis_result_tdata);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF S_AXIS_OPERATION:M_AXIS_RESULT:S_AXIS_C:S_AXIS_B:S_AXIS_A, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn_intf RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_A TVALID" *) input s_axis_a_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_A TREADY" *) output s_axis_a_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_A TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_A, TDATA_NUM_BYTES 2, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) input [15:0]s_axis_a_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TVALID" *) output m_axis_result_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TREADY" *) input m_axis_result_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_RESULT, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [31:0]m_axis_result_tdata;

  wire aclk;
  wire aresetn;
  wire [31:0]m_axis_result_tdata;
  wire m_axis_result_tready;
  wire m_axis_result_tvalid;
  wire [15:0]s_axis_a_tdata;
  wire s_axis_a_tready;
  wire s_axis_a_tvalid;
  wire NLW_inst_m_axis_result_tlast_UNCONNECTED;
  wire NLW_inst_s_axis_b_tready_UNCONNECTED;
  wire NLW_inst_s_axis_c_tready_UNCONNECTED;
  wire NLW_inst_s_axis_operation_tready_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_result_tuser_UNCONNECTED;

  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "0" *) 
  (* C_A_TDATA_WIDTH = "16" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "16" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "0" *) 
  (* C_B_TDATA_WIDTH = "16" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "16" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "0" *) 
  (* C_C_TDATA_WIDTH = "16" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "16" *) 
  (* C_FIXED_DATA_UNSIGNED = "0" *) 
  (* C_HAS_ABSOLUTE = "0" *) 
  (* C_HAS_ACCUMULATOR_A = "0" *) 
  (* C_HAS_ACCUMULATOR_PRIMITIVE_A = "0" *) 
  (* C_HAS_ACCUMULATOR_PRIMITIVE_S = "0" *) 
  (* C_HAS_ACCUMULATOR_S = "0" *) 
  (* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) 
  (* C_HAS_ACCUM_OVERFLOW = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ADD = "0" *) 
  (* C_HAS_ARESETN = "1" *) 
  (* C_HAS_A_TLAST = "0" *) 
  (* C_HAS_A_TUSER = "0" *) 
  (* C_HAS_B = "0" *) 
  (* C_HAS_B_TLAST = "0" *) 
  (* C_HAS_B_TUSER = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_COMPARE = "0" *) 
  (* C_HAS_C_TLAST = "0" *) 
  (* C_HAS_C_TUSER = "0" *) 
  (* C_HAS_DIVIDE = "0" *) 
  (* C_HAS_DIVIDE_BY_ZERO = "0" *) 
  (* C_HAS_EXPONENTIAL = "0" *) 
  (* C_HAS_FIX_TO_FLT = "1" *) 
  (* C_HAS_FLT_TO_FIX = "0" *) 
  (* C_HAS_FLT_TO_FLT = "0" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "0" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_A = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_S = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ADD = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_SUB = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_PART = "xcku5p-ffvb676-2-i" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "24" *) 
  (* C_RESULT_TDATA_WIDTH = "32" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "32" *) 
  (* C_THROTTLE_SCHEME = "1" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "kintexuplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  floating_point_3_floating_point_v7_1_18 inst
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(aresetn),
        .m_axis_result_tdata(m_axis_result_tdata),
        .m_axis_result_tlast(NLW_inst_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(m_axis_result_tready),
        .m_axis_result_tuser(NLW_inst_m_axis_result_tuser_UNCONNECTED[0]),
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(s_axis_a_tready),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(s_axis_a_tvalid),
        .s_axis_b_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_b_tlast(1'b0),
        .s_axis_b_tready(NLW_inst_s_axis_b_tready_UNCONNECTED),
        .s_axis_b_tuser(1'b0),
        .s_axis_b_tvalid(1'b0),
        .s_axis_c_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_c_tlast(1'b0),
        .s_axis_c_tready(NLW_inst_s_axis_c_tready_UNCONNECTED),
        .s_axis_c_tuser(1'b0),
        .s_axis_c_tvalid(1'b0),
        .s_axis_operation_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_operation_tlast(1'b0),
        .s_axis_operation_tready(NLW_inst_s_axis_operation_tready_UNCONNECTED),
        .s_axis_operation_tuser(1'b0),
        .s_axis_operation_tvalid(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
DsXmnUUn9ofwbg37p4K4tzmI01Z+3chbkfCkY3fvljnV8b0Bg2YwrKYVgHvy5VMmeiAP0SYV+o4T
+Hrb48jOjdz0iX1bT9Z9CwP6Q+AwNEYERMCFkOyAnVWobjX080y8WK/alRBJ3f31AqW5aJL86/A/
uwPakaLTofxRZo9velg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rwKh/q54hU57ACTwIM12TOQ2aV2+3F/nlpMH3SfcH/8LjcNr03gHM1sPz81RYMqb6RFEN+4buAkq
fLkYsZWP8ASmnr7Xz9dC5hilKF2ocs4/Jr8CIn45/7nGpwkQb4I6RJcfcDHj+yL8AFMH7frNNedx
1jKUiQNFUjN7zJYE4hRpUJosVjjlmjaI6luTgoXidLyI+Z783eXrzldJ9vsdCLf+D1SVYPwdL2i7
pKVrXzgSTPJG+0iBVjc0D8yyfeVtrtW/jkScpYlLUGtwC08L1E+e6ExDiL5xDIzZ4CeWlLo2FKcl
aqRxsCvAo/9fyD3neJyonNGyfeoCwLMoyDk4Bw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
nrcozBBG3V8XBWyrN1yfVIcA2pxTt0t7cn7UJKEzunruyCb51/R3KWFWKeyPZ1PtQaUSDpF9NEvN
vGN7Q/UmQFHuaYM3InFFLjkEI+Ys54yeiGYOoF5GyzbiHh1RrogXD5ATWN/SbAkeeXCZ1hxQ2b24
YW8fMEUoGldgjPJyw4Y=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
diLgSSPiT8vNEnclxMMHFZk+AteBju5K8CW5QMopcodPQ5+PGx55M5dHke65bIKSNCR4skbyYvAc
dXJgegw3wXvDbLQvbp3jsDQ76n9G6JzDtx9ipPCnzJmAhgEKPuXqyzks7Nq7oNTT1oIswj13jeCM
DWzMabVb54LDRHkomSGE/yhDGRRiUfKBqbWqBpXZ6shn8MhH7xtNDbozmOadCf8NowYZax1+eKt3
+RjTs1z4FmQCaRGTPWWSgiyA5NVF5YgLGnvCxv+mzNUJlXeZ8sFzaITOZwu9y6h0KbyeOoCV0IPc
VsGdnXlp+ig9m5rwSezodTzv99fQLV2lx7wSHw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jHVO77vxJ6fiQmEmEBXkmbYFW9LcfdU9nPxSCaMGwURhCcT3wInMHXzJJK/9zQH0MW1EvaZpPSbM
7Qnjmet308oNAUb9XEp53dxYG6y6ZALVUNt3TiAtfen/kNV3Fdq8B6ZelLuqWW3ihkn9SPAmjIbX
eg8OLbT8jesA6Q5UGGKBMBRCrfVzARhNUqjY2SyNST4/T57wxZHONxl7Mt/fjwTJTz9ckqTDsaLq
xHE5XSGeF+v0oZw+v4f2XBze2ajtHbx3JnA8uN7JokIU+SXk8EAgSlZQtbFsP45ObIQ7E3NYvEuS
ikPiiDi0f0XiaWxmRZkbE73w5LuOkg9G9dRMBA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j24WBSRNFaA8KA7eG8xzMw4dthGNLprxDCeCYUwkzyVedmTdb357ZCKFKa/ZJgpk8WiMgKjRfHch
I5PZtp1e+iAGsK47t9ZLtxgXAeU8Rj6g2J6AxpyAdNqaQ+UMtv7ju5IVy/urLoB1Rxvgy5YjNdS/
VfOYXDeixDyz+0dn93NQNqAcbCQeUftuvdlPlNYNo9AZphqNmWJZ/JfAt2m5AoZApqrM/y/Z74XA
NQgW7W1Gw7HzE4GKGFM1eUyHRgKsYie5h5/1KUXdP8Bwa0FN0udy49tl8U1dO/sORs9r/t1QXvJc
u+cGgyfsFHkl/nRKINsJBp8/dEsbTQf+ar4GGA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
B8DvaWNwR4VE6+PvvAUnPueeHWDaAVBdKr/zuLhFCm2ejjEIW+4lZt+P8F587K7K1iPLHR1BaTkt
FYE4hly7rXmmRfxe2R1NtAZh9GDy8GTgAk7QE0vcwkqdhalXOLQfYffHv9py6Xr9oCtB1avXN6rg
1xUvfQed5kx5QTa4dZKXMqskDtVD+gQ4gkw1V4TiyNn9t+ZgLCTQbRGPyg1yyHPdVULucKNbnrkX
MkVl4n2oOdNmLvq3ttwKYd10m1WttmRNHuqthj/tg3VWURiMSB4vWPTojBIUvckZfP2EBB8nwFT7
6buU6N4OwRzIrDZCpPx7XBNiq7iriRHm+vayqA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
OXUKmJNS4Va7sTPUOvV2XS2D9z3xzjRRF/TxGoEllE2Ly3GsGTDFUt/uw7GtMDrzZ9R6EgG59c5F
P4z3GOV2CCVka/CW8NqiJXO7qkOd69Y4P6pLBF5LgFF4tF7ykJasl2WJCYfTvtNxcDorkS0vExII
XbJOcU/NdHGDtHcgTt5MkUDuWQcmOE7JKBlO30ai4TEwoQ9j8s7jCR4S7ds4EU0KynLNvPtswQmd
v0A+BNUlAQ/xHBgbB0zie9COC1Va0aGzI0fiUKau91TpCvcW5EKd9ax85/s/6ZX7427uNQSMjil9
W5cShs2EB3xPP4jKOgX/fb3xtZfjord9HaHxANnDk0Iia88Euy2XEexPp3Z8lDUig+QVyYeIRSHc
BTlf5jw6B2wOGKNzFn+NV2r8edQBx+nulc7HRNo1HAFgfA0G+rdack2sgK4ec4SHDdq6VSc21doR
CDvkHr0AAZW6i7ct26lbA7AUH5unCCq6IoIOmuk2dXQ07KRNx/r9lqTh

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WT3Y+FzIMkCrNSFRM2OVscEwcBBU6PK2L8mWaJA87gqTPcYfS6Zh4aZPJDq8Q7ZqP+AFgyDrtcTv
4GgA1cU5oijOe4DY1j1GBhhls8Ri5NdoH4YdrJEm5S6eVclmaxzt875QfYonCKv7+kFRj2CdXsEE
3a9DQ0hLKTUjK+e7Vlo0aI744XEBy6EC4vjysuiIqDP3s9uma3p+7yAf1EiGDx5MAUHo/3P1Vrca
mfYqGI+xdJeoeFeaVZVCeRyDGlCWZ7OZu1NaBoHZB3ErvA0ftTpXHPSpsBRhw2zE+cO+pK90TXnH
A6/qE35h5MlNz19oQ4X6iYPi5+YxSmWSnpixmA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a9mwAXmmYESxhZJ0xVsKjFFaRHE1BCLtq47bqWERSPSjF1k2G8l6NHaviu6OfZs9JaakGJVSfG0Q
NfRBF5szzW7cg3Irvwn9vfLez3mwtbNwfgJ0yMuZ+xln1vvIAX51xpeMw1TYSLkGvdw63auulUTE
8S/hqIveZH4/dRwXxRyfgc2qVQdYpzbejVn+MXXjRVFKfWgb3LstRMs988E/sSaBFTMHY5hEbEuy
+w4LQFi5sJTeyvJp0aXsTHFc7ijWve2TNXIC1oq3C9zk0UxoE/YW81QN7tT4OtA0fin1hQDWklIG
BDNWd3EIYB34PC1k6qbiOlOUGCMdka1E04Zs/g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
AoAu+9DtirAkUXGUlaHNUWeoGhs8MaqM/sRfUvn5X7jfkmV58589lx+0ewYW0KcAf/lRWCoPclEf
0bI8AmdG1oNcLdm3MwVhRLOKpiMg+3ekxauv2UEgwtE1PGelXax5yNgE5vsz/C60y3Ebjgrdsm4f
Ov5zE1qT8FxchY1upqe+w1Daku+hJnpXGAS8g0kncFcXKppIKi/4S6gG3gtZJ+vbSe/lKTIOfw80
UFVTrCKJGb3YEtR4eTP+h7MhVgbBKxptcO9Nc366e3YQkT+1xAYA6cLnrEOe+/Rv9FPfr6nrHIe7
ufdN40UrWTYkxGaTwR+oB05t4MnUvJkus2a8ag==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 8800)
`pragma protect data_block
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
ngtIY/IkyhQFufpNa/qj45MilzkU1g==
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
sbwmcC85YZTbqIlm0gRQorBNlDAF8CF1C6WuxNVzZalif8xy2aUyH5O9Np4TYfCYpI2fUs3QPLQx
CQvhPYrYPB3JI5Zl3k9zKGgvAWbuorLYken7jR1HL8ORFwk/3YcpdQnz2C1o851LDJ+8Z/RYa+HY
2X5mm+7JM74lZe54SMM=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
b5JBfbODGamuNEXS42TSGH+xweUEtZpv2wMSU4F0db5miS0nVOsBBpPAUk1QuykbhDYiOCdASt4u
A1kCygq0Q9Syuf+71Aq+UhIdPI92Z+/1AmKnSKnWe90/nWvGEsyqkBU5chBv0HjMKcIQ/Dkmnsft
7aOSnEDXDwVdXc9zU9XEi592myvVabaAKBrHAmxiVachWDC9d/MmDFakmfAkpwyFlotvttyXV3eS
uJaNZA5L+rvbfZE6cs2DDSadqpY4GnJYc19CY0Fgbr6C46Bo9nHAIhXxd0iRHdKwHtqzKrfZ+C16
tIYr+oXINVyNQ54ED0U84T+IZmH17lrqtuSjpw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
f7dxWY1kMA1wEELeO/IuVoIPyk3v4O8eJDMGPeKbZyxKMaIYsl0Nw8974nDdDiRS4mWOfmpUVwzk
q+2BjuzUPniWvBM+2GDnkjHoa3mPY/2wI5RLYFGTnvNPyWXetAwptsO3wip4F+dK3AMVamHtk6Xb
8Ed/jeUopsufqE3hx5E=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
E+xQdTzSVaWhhlGjtQ7GGt2LcsgblohSLrZarA9uA+oUkjaz7LFR32+7CJXhz1V/i9JYaBKVUM6M
JfWRlh7U2neOkbalo1E70T1z3/TDXldKnMCAdc+WrqiHZsb2L7PN+uSJUHdBMlx8iLEceq5g7T+k
j5asn5upXHwr2vP+TbZza5rQfLFsrFC8l9rC6rseBJVU8srImje22igGynI3ISZBR3o931s5aBS4
oXK0gi2M3LL3bio+IDaPX2N34zRAZXX5Pu2GnoqqCq+kMK7p52DPb51o7MYZch1AG6XgbnfxMnjU
P5tILFV6hQjKU1109BH73B24jb3ribMVP1OmJg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
J8yHRhK97IvqKR3x3bZV+NXvsSRfGzeomCIoCLJmAD0OM4alJrZNNgwHpHF6Qg3AUZfD34KxFZDV
d86Uh4bvH6IrN36Pep9HLL8cohqW3LRLs+KYUmYLYorwg0T2Fm5bCGaXIrE6TOq1ldyjiDySRV8d
iRO3OPBxVooLAVzf/RHrkG2qBE8QgmIu170/eGmV8hNsWauK9s/h4jPyynSE3jIIB+V9D8YebNtP
+RKqdBpmDMgF0tGhUOwl+8oVlMaDet1bLd6wdI4YoOycNJTIL8mLM1qG9nNwuLVIFObCdISouo8X
OmwZOVFJGh0tW41BTf0MT4v7pfJkHUBE+UNqsw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WNddGSvOG+nNvpPnq1cVJnAOgW2qA2/h1ihEakGRJwxpkN7dPMaRUhUWfbMOQ6La1cKG59MZ21+I
FrYnbthWRMeWkOVPvEc/ojYMoVGOeBkjUrFI7/lAzcfKl/M/F27bbcy9HLTRFKVePWIHjhLmrcd3
btfe+PjJBuWoPBPZzEOchXFykvZR4UgccKUkMWRyxZRgxoCrNboyQv2/4RS+4X4zYOM4Iv3tE7vH
Y1sWPpvxCxqjwo0EGUUiHkhRn2uF8BXRduHhROjeSW6eXcoGCQMBiRQDdKltEqb+iLZT0mzpLQya
UylJQ+4djJNBGbWy7bG2fqX+SxUWSdpEGgBBgw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WlGTCJZ6I04XWDMD/snaFX6VeXwXQaiXE9QZGuEJLcZvW5LMWFkNVT7PbIC4cZGPNRBZFr6DnENP
QDk1abMVKsL0pUv20AjHlN7qC3vwxkoCAfb568rskM8s3nDB3Vrsvg8ge5/JUOwo5jU6mTzDejS0
8swNU2WeNLZ/8FpVj3giRqHGou58P+TQNNrcKa7wP13f7IDzF0cAG5W9mGw3Yzs8RIQ1MtOc4jvH
G9dLW6Xoh+i812BtMsVZ+E2wAeyIOgSzNlBM47s3drkjCYSXs5x1D6QqP3/rsOC2CymVDUleQ866
E9b5W4Q37PUAkbg+vX9yGhJgRMJEM5qifS1NFQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
s/Cj+WkxnXbbJDJSKc4EBvB2nnDEa+NjeYJxNG/QOYQtQ7MMdMehKa5jG6UM5GkoI85rZHE1lRjR
4JNnsp6RHranJ1Xi+b/dWBqQmQyMhydRqdzyRrGNuPD4XjvAya5UYewvlTs4uq9kwFxKJMuf/KAg
L8C8I/cK6FPlTd0DY+RTV9lEZ4JRyBhFdRtjtMDU88r9k3HnILK2F75s24FiJk6HVzd4SYMkUBIV
k8SK0Jdn81aBkuqSANS2KjV0aDOfkRzm+Rl8E5LUC3/tc4qHXtAlQauqlLnt4Op2SZ+dO7KuYLpm
ucY8K9U1dzGewJK5HZ/YuF9EGaOdiRGTexny35zr+gYT9lZNGxWjA+SjSywbYmumfhOjbH+ymLev
/rPJ4WEgFAIVn3g5YuYa/H1rTttqEMXmshzb8jS8ChFOPMWWXFbq2TehCR9LEUnCB+mzTJ25aBW0
bX0NK+mz827OrlGcJDDBiwQEl+metYSnhh1xwCSCzb774E3aG11RevAH

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UOO+Z2dCcD7EbH2zj7QBUOWLcmYYhT+j4OdMKDkYaoIakSE1XJj0wJV2ubaYNmaF3sjx6HvN7bLf
yDaCmll7J+ngr+jzPZyK1As3syf28x9+Ry6AgIlHzkriPWlHZlEg75cnCmp2tg9em9d3znAm3hNk
f15a5SOGundf0d/r6kpT0WxtLR0JO64y4JlZJnMP4OmdBvf7ifG7eNJ2sT/Du2y6VMlfmEmLhdtx
Z55I7s7/ABmr75OVB36ZreVNqWv3YDnMfA3lNjrwn3X9naqoSOPnh2ADGKXivgOLMzoCN/mLj7z4
KgR+Wvn8XVsRBDGbcB55zwu+B9G7V2Ir/FcE/A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KYSREWW+IjPdWwP3vnXCbCVJhEMGy6YKdf7tdbgvl7vM+koveWhtr7utk+aOHMeHXXWaq5ZJ+mCg
lCMBSzon0I+Q3kSmyXUVAcfF96eNj9MXsoeJ6ug7V0+32mLEgFrteLuTmYmJfQetNLyLhyaGmRkK
uw2+qE7lCKI9g62i27W7fWAnnvIephykr4SDLD8RyLGruqAW2CUcy2y1kQZ4uDOpxg8HGhzW8zHv
EZIjCxWOx55ozRdxKq/sKehXvWNB7f+Fr4NMJD+KMVmv1AgWgaG4Hd6txzDJCxU/4a6ENjGtiz5V
60DDWdmSxYx5eGGmZUrTbSyoQtfESpi/gi4nBw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kL8RB70c5CAnPqRnBaDm/O8eNzMynZfSpdkeO03c/IUBdoiS6Numfz8GtPIkLgBoYgGBkNrzzG62
Aqmwztaj/rrwqau9xFn6Te7kPPv1/fvna5/OJVyrKNOcON0Bz0oWquWRr55RH49EtuvdcUPy+IVo
EIKcH+mBCG40XWCe9ni77MWEdEcbIl+ppNlmfwRevBgSnZ2Ced02IfpyASQfI0aqaVzFMRBffocm
ajWqtzzilmQxpYTK/HUTlJfXxygfYfLJDJQQY1pghTdfzsFKXXhtAVp61AKQJvpSxO+sQLiJQSWU
m5sTaanQEaPKRpKhmlrGvOxcSOLTDtqULC3aEA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 67264)
`pragma protect data_block
+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
4YLCI/JKF4B5gMoz/mFhwySCOW3+xRSddzogjRfievHY8tnKtDXBvrXXXsIstapa5LMKzxc52l2T
JtGBu2d1rxGliAQLT7NV2XNkfT8hypUbPfJ4uFmN9wsGdWWouykK6zSFK7xjAznMGtp4wfxxJ/uC
dL1Mmm+G3lagrntxnO66UOG2dmx/TKsfNW/f24WF2MO4merK0k79LdVlj90rVCNrZrvDsdcp0yu7
plTCbBT1cRRqTl6aOg4U4xej4lNuUemKR7FKmAzrykVBx1ZCTqPA6VqxcG8JEQT0w5hU3NuBhTrP
cCrmbr15Shgp3tChjj8i83VDh4Lw678ego/fHCv5MXWqhuVciLOyK52eKc/TqLIeUmg++8osclv9
xhJOQAUUnN6WtpcqhlJHSlxjcXqM3ENGm4yf723L00ejHSMH/pqwZ374zAfCffK0SNn8C0uV8ekR
p3mCJPR8ZEOuXrb8IxG0O9C9HIr7iYNk1JSKAg4rlyJ22aNB4GVrrhxRjYeTq6Q98AI0D+BjtLL6
vEEAcGilKqYucGOpawEmMSh7cr+FGtR1Nq0KDa6MO5ceTsWeKdKZ7tvIBjI4uIAiRsK+jIUpr9fP
ce1HE9trZs+539MiS7wnPPKO6hTtzBJJZs0LVaRNvTIDrMX3/P89T/nh08B53KRdvIeYou23Wg1P
atXtvTFWe8CsPF1qa44g7LRGq/txw86Muj4/gGaPJ3nvgyJL6Nerlb3WhXuTe6nkiqidklHMxAnr
t106zt/vY7RqiaDRtNVYoC+82fgvaS/JZXVnpzFmjzuw/fpSkXHdJxJNTgk+kjxaoJ4gtWHdNGzk
FEq/FLNx9p2nQDie46gyrFhuZL19SjRY+Ey2ot6RZ0JmlwNafkGLGK8WK2izRNNWozSSopgPfSm1
hoq/Nkibg/IvOWySY5u0L+Sz5ckm9zZfIm2IVwqirnz5+elY9ZsuQ5hPx35PgkdeKKHMWsVbXl39
by3tAcE5lLxubBtHp+J2ZnkqymofaA1uBQu5EW8cm4HH+kpeSuqWMUNfws2+p3gqrvnFaEPxhSju
8YjwzfyPpXkoNXUcQICcugtsMt0he5OJkgOex4nEI+vmIMFG7pJjH/4pUML7l8ZS57n6S6wQ/NYs
PenIw1A4XQvrFT4uu5w05+lqa0jWrM6ufRzWC4z8pK5tS9GsoEdv6zB2MFpw9VJgY8+AeR/hsh74
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
jNF/cA==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
