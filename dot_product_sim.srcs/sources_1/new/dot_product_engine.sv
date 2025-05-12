`timescale 1ns/1ps
module dot_product_engine #(
    parameter int MAX_N = 128,
    parameter int DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  rstn,
    input  logic                  start,
    input  logic [2:0]            data_type,
    input  logic [7:0]            shift_width,
    input  logic [MAX_N*2-1:0]    A_row_packed,
    input  logic [DATA_WIDTH-1:0] x_vector [0:MAX_N-1],
    output logic [DATA_WIDTH-1:0] y_out,
    output logic                  done
);

    logic [15:0] N_used;
    always_comb begin
        N_used = 256 / shift_width;
    end

    logic [15:0] A_raw [0:MAX_N-1];
    always_comb begin
        for (int i = 0; i < MAX_N; i++) begin
            case (shift_width)
                8'd2:  A_raw[i] = (i < N_used) ? {8'd0, A_row_packed[i*2 +: 2]}  : 16'd0;
                8'd4:  A_raw[i] = (i < N_used) ? {8'd0, A_row_packed[i*4 +: 4]}  : 16'd0;
                8'd8:  A_raw[i] = (i < N_used) ? {8'd0, A_row_packed[i*8 +: 8]}  : 16'd0;
                8'd16: A_raw[i] = (i < N_used) ?        A_row_packed[i*16 +: 16] : 16'd0;
                default: A_raw[i] = 16'd0;
            endcase
        end
    end

    logic [DATA_WIDTH-1:0] A_fp32 [0:MAX_N-1];
    logic                  A_valid [0:MAX_N-1];
    generate
        for (genvar i = 0; i < MAX_N; i++) begin : GEN_CONVERT
            intN_to_fp32_wrapper convert (
                .clk         (clk),
                .rstn        (rstn),
                .data_type   (data_type),
                .raw_data_in (A_raw[i]),
                .start       (start),
                .ready       (),
                .result      (A_fp32[i]),
                .valid       (A_valid[i])
            );
        end
    endgenerate

    logic [DATA_WIDTH-1:0] prod_fp32 [0:MAX_N-1];
    logic                  prod_valid [0:MAX_N-1];
    generate
        for (genvar i = 0; i < MAX_N; i++) begin : GEN_MUL
            floating_point_1 fp_mult (
                .aclk(clk),
                .aresetn(rstn),
                .s_axis_a_tvalid(A_valid[i]),
                .s_axis_a_tdata(A_fp32[i]),
                .s_axis_b_tvalid(A_valid[i]),
                .s_axis_b_tdata(x_vector[i]),
                .m_axis_result_tvalid(prod_valid[i]),
                .m_axis_result_tdata(prod_fp32[i]),
                .s_axis_a_tready(),
                .s_axis_b_tready(),
                .m_axis_result_tready(1'b1)
            );
        end
    endgenerate

    logic [DATA_WIDTH-1:0] sum_stage [0:6][0:MAX_N-1];
    logic valid_stage [0:6][0:MAX_N-1];
    generate
        for (genvar i = 0; i < MAX_N; i++) begin
            assign sum_stage[0][i] = prod_fp32[i];
            assign valid_stage[0][i] = (i < N_used) ? prod_valid[i] : 1'b0;
        end
    endgenerate

// Stages 1 to 6

    // Stage 1 - 64 adders
    floating_point_2 add_lvl1 [0:63] (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[0][0 +: 64]),
        .s_axis_a_tdata(sum_stage[0][0 +: 64]),
        .s_axis_b_tvalid(valid_stage[0][1 +: 64]),
        .s_axis_b_tdata(sum_stage[0][1 +: 64]),
        .m_axis_result_tvalid(valid_stage[1][0 +: 64]),
        .m_axis_result_tdata(sum_stage[1][0 +: 64]),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

    // Stage 2 - 32 adders
    floating_point_2 add_lvl2 [0:31] (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[1][0 +: 32]),
        .s_axis_a_tdata(sum_stage[1][0 +: 32]),
        .s_axis_b_tvalid(valid_stage[1][1 +: 32]),
        .s_axis_b_tdata(sum_stage[1][1 +: 32]),
        .m_axis_result_tvalid(valid_stage[2][0 +: 32]),
        .m_axis_result_tdata(sum_stage[2][0 +: 32]),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

    // Stage 3 - 16 adders
    floating_point_2 add_lvl3 [0:15] (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[2][0 +: 16]),
        .s_axis_a_tdata(sum_stage[2][0 +: 16]),
        .s_axis_b_tvalid(valid_stage[2][1 +: 16]),
        .s_axis_b_tdata(sum_stage[2][1 +: 16]),
        .m_axis_result_tvalid(valid_stage[3][0 +: 16]),
        .m_axis_result_tdata(sum_stage[3][0 +: 16]),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

    // Stage 4 - 8 adders
    floating_point_2 add_lvl4 [0:7] (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[3][0 +: 8]),
        .s_axis_a_tdata(sum_stage[3][0 +: 8]),
        .s_axis_b_tvalid(valid_stage[3][1 +: 8]),
        .s_axis_b_tdata(sum_stage[3][1 +: 8]),
        .m_axis_result_tvalid(valid_stage[4][0 +: 8]),
        .m_axis_result_tdata(sum_stage[4][0 +: 8]),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

    // Stage 5 - 4 adders
    floating_point_2 add_lvl5 [0:3] (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[4][0 +: 4]),
        .s_axis_a_tdata(sum_stage[4][0 +: 4]),
        .s_axis_b_tvalid(valid_stage[4][1 +: 4]),
        .s_axis_b_tdata(sum_stage[4][1 +: 4]),
        .m_axis_result_tvalid(valid_stage[5][0 +: 4]),
        .m_axis_result_tdata(sum_stage[5][0 +: 4]),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

    // Stage 6 - 2 adders
    floating_point_2 add_lvl6 [0:1] (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[5][0 +: 2]),
        .s_axis_a_tdata(sum_stage[5][0 +: 2]),
        .s_axis_b_tvalid(valid_stage[5][1 +: 2]),
        .s_axis_b_tdata(sum_stage[5][1 +: 2]),
        .m_axis_result_tvalid(valid_stage[6][0 +: 2]),
        .m_axis_result_tdata(sum_stage[6][0 +: 2]),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

    // Final Stage 7: 1 adder
    floating_point_2 add_lvl7 (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_a_tvalid(valid_stage[6][0]),
        .s_axis_a_tdata(sum_stage[6][0]),
        .s_axis_b_tvalid(valid_stage[6][1]),
        .s_axis_b_tdata(sum_stage[6][1]),
        .m_axis_result_tvalid(done),
        .m_axis_result_tdata(y_out),
        .s_axis_a_tready(),
        .s_axis_b_tready(),
        .m_axis_result_tready(1'b1)
    );

endmodule
