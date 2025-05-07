//=====================================================================
// dot_product_engine_fp.sv (Adder Tree Version)
//=====================================================================
`timescale 1ns/1ps
module dot_product_engine #(
    parameter int N = 64
)(
    input  logic                  clk,
    input  logic                  rstn,       // active-low
    input  logic                  start,
    input  logic [8*N-1:0]         A_row_packed,
    input  logic [31:0]            x_vector   [0:N-1],
    output logic [31:0]            y_out,
    output logic                  done
);

    // --------------------------------------------------------------
    // 1) Unpack 8-bit weights
    // --------------------------------------------------------------
    logic signed [7:0] A_int8 [0:N-1];
    generate
        for (genvar gi = 0; gi < N; gi++) begin
            assign A_int8[gi] = A_row_packed[gi*8 +: 8];
        end
    endgenerate

    // --------------------------------------------------------------
    // 2) Int8 -> FP32 Converters
    // --------------------------------------------------------------
    logic [31:0] A_fp32 [0:N-1];
    logic        A_fp32_valid [0:N-1];

    generate
        for (genvar gi = 0; gi < N; gi++) begin : GEN_CONV
            floating_point_0 int8_to_fp32 (
                .aclk                 (clk),
                .aresetn              (rstn),
                .s_axis_a_tvalid      (start),
                .s_axis_a_tready      (),
                .s_axis_a_tdata       ({{24{A_int8[gi][7]}},A_int8[gi]}),
                .m_axis_result_tvalid (A_fp32_valid[gi]),
                .m_axis_result_tready (1'b1),
                .m_axis_result_tdata  (A_fp32[gi])
            );
        end
    endgenerate

    // --------------------------------------------------------------
    // 3) Multipliers
    // --------------------------------------------------------------
    logic [31:0] prod_fp32 [0:N-1];
    logic        prod_fp32_valid [0:N-1];

    generate
        for (genvar gi = 0; gi < N; gi++) begin : GEN_MUL
            floating_point_1 fp_mult (
                .aclk                 (clk),
                .aresetn              (rstn),
                .s_axis_a_tvalid      (A_fp32_valid[gi]),
                .s_axis_a_tready      (),
                .s_axis_a_tdata       (A_fp32[gi]),
                .s_axis_b_tvalid      (A_fp32_valid[gi]),
                .s_axis_b_tready      (),
                .s_axis_b_tdata       (x_vector[gi]),
                .m_axis_result_tvalid (prod_fp32_valid[gi]),
                .m_axis_result_tready (1'b1),
                .m_axis_result_tdata  (prod_fp32[gi])
            );
        end
    endgenerate

    // --------------------------------------------------------------
    // 4) Unrolled Adder Tree
    // --------------------------------------------------------------

    // Stage 0 - 32 ADDERS
    logic [31:0] sum_lvl1 [0:31];
    logic        sum_lvl1_valid [0:31];

    generate
        for (genvar i = 0; i < 32; i++) begin : GEN_ADD_LVL1
            floating_point_2 add_lvl1 (
                .aclk(clk),
                .aresetn(rstn),
                .s_axis_a_tvalid(prod_fp32_valid[2*i]),
                .s_axis_a_tready(),
                .s_axis_a_tdata(prod_fp32[2*i]),
                .s_axis_b_tvalid(prod_fp32_valid[2*i+1]),
                .s_axis_b_tready(),
                .s_axis_b_tdata(prod_fp32[2*i+1]),
                .m_axis_result_tvalid(sum_lvl1_valid[i]),
                .m_axis_result_tready(1'b1),
                .m_axis_result_tdata(sum_lvl1[i])
            );
        end
    endgenerate

    // Stage 1 - 16 ADDERS
    logic [31:0] sum_lvl2 [0:15];
    logic        sum_lvl2_valid [0:15];

    generate
        for (genvar i = 0; i < 16; i++) begin : GEN_ADD_LVL2
            floating_point_2 add_lvl2 (
                .aclk(clk),
                .aresetn(rstn),
                .s_axis_a_tvalid(sum_lvl1_valid[2*i]),
                .s_axis_a_tready(),
                .s_axis_a_tdata(sum_lvl1[2*i]),
                .s_axis_b_tvalid(sum_lvl1_valid[2*i+1]),
                .s_axis_b_tready(),
                .s_axis_b_tdata(sum_lvl1[2*i+1]),
                .m_axis_result_tvalid(sum_lvl2_valid[i]),
                .m_axis_result_tready(1'b1),
                .m_axis_result_tdata(sum_lvl2[i])
            );
        end
    endgenerate

    // Stage 2 - 8 ADDERS
    logic [31:0] sum_lvl3 [0:7];
    logic        sum_lvl3_valid [0:7];

    generate
        for (genvar i = 0; i < 8; i++) begin : GEN_ADD_LVL3
            floating_point_2 add_lvl3 (
                .aclk(clk),
                .aresetn(rstn),
                .s_axis_a_tvalid(sum_lvl2_valid[2*i]),
                .s_axis_a_tready(),
                .s_axis_a_tdata(sum_lvl2[2*i]),
                .s_axis_b_tvalid(sum_lvl2_valid[2*i+1]),
                .s_axis_b_tready(),
                .s_axis_b_tdata(sum_lvl2[2*i+1]),
                .m_axis_result_tvalid(sum_lvl3_valid[i]),
                .m_axis_result_tready(1'b1),
                .m_axis_result_tdata(sum_lvl3[i])
            );
        end
    endgenerate

    // Stage 3 - 4 ADDERS
    logic [31:0] sum_lvl4 [0:3];
    logic        sum_lvl4_valid [0:3];

    generate
        for (genvar i = 0; i < 4; i++) begin : GEN_ADD_LVL4
            floating_point_2 add_lvl4 (
                .aclk(clk),
                .aresetn(rstn),
                .s_axis_a_tvalid(sum_lvl3_valid[2*i]),
                .s_axis_a_tready(),
                .s_axis_a_tdata(sum_lvl3[2*i]),
                .s_axis_b_tvalid(sum_lvl3_valid[2*i+1]),
                .s_axis_b_tready(),
                .s_axis_b_tdata(sum_lvl3[2*i+1]),
                .m_axis_result_tvalid(sum_lvl4_valid[i]),
                .m_axis_result_tready(1'b1),
                .m_axis_result_tdata(sum_lvl4[i])
            );
        end
    endgenerate

    // Stage 4 - 2 ADDERS
    logic [31:0] sum_lvl5 [0:1];
    logic        sum_lvl5_valid [0:1];

    generate
        for (genvar i = 0; i < 2; i++) begin : GEN_ADD_LVL5
            floating_point_2 add_lvl5 (
                .aclk(clk),
                .aresetn(rstn),
                .s_axis_a_tvalid(sum_lvl4_valid[2*i]),
                .s_axis_a_tready(),
                .s_axis_a_tdata(sum_lvl4[2*i]),
                .s_axis_b_tvalid(sum_lvl4_valid[2*i+1]),
                .s_axis_b_tready(),
                .s_axis_b_tdata(sum_lvl4[2*i+1]),
                .m_axis_result_tvalid(sum_lvl5_valid[i]),
                .m_axis_result_tready(1'b1),
                .m_axis_result_tdata(sum_lvl5[i])
            );
        end
    endgenerate

    // Stage 5 - Final Adder
    logic [31:0] sum_lvl6;
    logic        sum_lvl6_valid;

    floating_point_2 add_lvl6 (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(sum_lvl5_valid[0]),
        .s_axis_a_tready(),
        .s_axis_a_tdata(sum_lvl5[0]),
        .s_axis_b_tvalid(sum_lvl5_valid[1]),
        .s_axis_b_tready(),
        .s_axis_b_tdata(sum_lvl5[1]),
        .m_axis_result_tvalid(sum_lvl6_valid),
        .m_axis_result_tready(1'b1),
        .m_axis_result_tdata(sum_lvl6)
    );

    // --------------------------------------------------------------
    // 5) Output & DONE
    // --------------------------------------------------------------
    assign y_out = sum_lvl6;
    assign done  = sum_lvl6_valid;

endmodule
