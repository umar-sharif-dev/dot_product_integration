 // =============================
// Scalable Dot Product Engine with Pipelined Accumulator Tree
// Supports N elements per row (configurable)
// Latency ~ log2(N) + 1 using parallel tree accumulation
// =============================

module dot_product_engine #(
    parameter N = 64  // Number of elements per row
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [8*N-1:0] A_row_packed,     // 64 x int8 packed (512 bits for N=64)
    input  logic [31:0]    x_vector   [0:N-1], // 64 x fp32
    output logic [31:0]    y_out,
    output logic           done
);

    // --------------------------
    // Local Parameters
    // --------------------------
    localparam int PIPE_DEPTH = $clog2(N) + 1;

    // --------------------------
    // Unpack A_row_packed into A_int8
    // --------------------------
    logic signed [7:0] A_int8 [0:N-1];
    genvar i;
    generate
        for (i = 0; i < N; i++) begin
            assign A_int8[i] = A_row_packed[i*8 +: 8];
        end
    endgenerate

    // --------------------------
    // Convert A_int8 to fp32
    // --------------------------
    logic [31:0] A_fp32 [0:N-1];
    logic [N-1:0] A_fp32_valid;

    generate
        for (i = 0; i < N; i++) begin : FP_CONVERT
            floating_point_convert int8_to_fp32 (
                .aclk(clk),
                .s_axis_a_tdata  (A_int8[i]),
                .s_axis_a_tvalid (start),
                .m_axis_result_tdata (A_fp32[i]),
                .m_axis_result_tvalid(A_fp32_valid[i])
            );
        end
    endgenerate

    // --------------------------
    // Multiply A_fp32[i] * x_fp32[i]
    // --------------------------
    logic [31:0] mult_out [0:N-1];
    logic [N-1:0] mult_valid;

    generate
        for (i = 0; i < N; i++) begin : FP_MUL
            floating_point_mul mul_inst (
                .aclk(clk),
                .s_axis_a_tdata  (A_fp32[i]),
                .s_axis_a_tvalid (A_fp32_valid[i]),
                .s_axis_b_tdata  (x_vector[i]),
                .s_axis_b_tvalid (1'b1),
                .m_axis_result_tdata (mult_out[i]),
                .m_axis_result_tvalid(mult_valid[i])
            );
        end
    endgenerate

    // --------------------------
    // Tree-based FP32 Accumulation using Adders
    // --------------------------
    // First stage: pairwise add mult_out[0] + mult_out[1], ...
    logic [31:0] sum_stage1 [0:(N/2)-1];
    logic [31:0] sum_stage1_reg [0:(N/2)-1];
    generate
        for (i = 0; i < N/2; i++) begin : STAGE1
            floating_point_add add_inst (
                .aclk(clk),
                .s_axis_a_tdata  (mult_out[2*i]),
                .s_axis_a_tvalid (mult_valid[2*i]),
                .s_axis_b_tdata  (mult_out[2*i+1]),
                .s_axis_b_tvalid (mult_valid[2*i+1]),
                .m_axis_result_tdata (sum_stage1[i]), .m_axis_result_tvalid() ); 
            
            regn #(32) sum1_reg_inst (.clk(clk), .rst(rst), .en_reg(en), .d(sum_stage1[i]), .q(sum_stage1_reg[i]));
        end
    endgenerate

    // Stage 2: Add results of stage 1
    logic [31:0] sum_stage2 [0:(N/4)-1];
    logic [31:0] sum_stage2_reg [0:(N/4)-1];
    generate
        for (i = 0; i < N/4; i++) begin : STAGE2
            floating_point_add add_inst (
                .aclk(clk),
                .s_axis_a_tdata  (sum_stage1[2*i]),
                .s_axis_a_tvalid (1'b1),
                .s_axis_b_tdata  (sum_stage1[2*i+1]),
                .s_axis_b_tvalid (1'b1),
                .m_axis_result_tdata (sum_stage2[i]), .m_axis_result_tvalid() ); 
                
            regn #(32) sum2_reg_inst (.clk(clk), .rst(rst), .en_reg(en), .d(sum_stage2[i]), .q(sum_stage2_reg[i]));
        end
    endgenerate

    // Stage 3: Add results of stage 2
    logic [31:0] sum_stage3 [0:(N/8)-1];
    logic [31:0] sum_stage3_reg [0:(N/8)-1];
    generate
        for (i = 0; i < N/8; i++) begin : STAGE3
            floating_point_add add_inst (
                .aclk(clk),
                .s_axis_a_tdata  (sum_stage2[2*i]),
                .s_axis_a_tvalid (1'b1),
                .s_axis_b_tdata  (sum_stage2[2*i+1]),
                .s_axis_b_tvalid (1'b1),
                .m_axis_result_tdata (sum_stage3[i]), .m_axis_result_tvalid() ); 
                
                regn #(32) sum3_reg_inst (.clk(clk), .rst(rst), .en_reg(en), .d(sum_stage3[i]), .q(sum_stage3_reg[i]));
        end
    endgenerate

    // Stage 4: Add results of stage 3
    logic [31:0] sum_stage4 [0:(N/16)-1];
    logic [31:0] sum_stage4_reg [0:(N/16)-1];
    generate
        for (i = 0; i < N/16; i++) begin : STAGE4
            floating_point_add add_inst (
                .aclk(clk),
                .s_axis_a_tdata  (sum_stage3[2*i]),
                .s_axis_a_tvalid (1'b1),
                .s_axis_b_tdata  (sum_stage3[2*i+1]),
                .s_axis_b_tvalid (1'b1),
                .m_axis_result_tdata (sum_stage4[i]), .m_axis_result_tvalid() ); 
                
            regn #(32) sum4_reg_inst (.clk(clk), .rst(rst), .en_reg(en), .d(sum_stage4[i]), .q(sum_stage4_reg[i]));
        end
    endgenerate

    // Stage 5: Add results of stage 4
    logic [31:0] sum_stage5 [0:(N/32)-1];
    logic [31:0] sum_stage5_reg [0:(N/32)-1];
    generate
        for (i = 0; i < N/32; i++) begin : STAGE5
            floating_point_add add_inst (
                .aclk(clk),
                .s_axis_a_tdata  (sum_stage4[2*i]),
                .s_axis_a_tvalid (1'b1),
                .s_axis_b_tdata  (sum_stage4[2*i+1]),
                .s_axis_b_tvalid (1'b1),
                .m_axis_result_tdata (sum_stage5[i]), .m_axis_result_tvalid() ); 
                
            regn #(32) sum5_reg_inst (.clk(clk), .rst(rst), .en_reg(en), .d(sum_stage5[i]), .q(sum_stage5_reg[i]));
        end
    endgenerate

    // Stage 6: Final result
    logic [31:0] sum_stage6;
    logic [31:0] sum_stage6_reg;
    floating_point_add final_add (
        .aclk(clk),
        .s_axis_a_tdata  (sum_stage5_reg[0]),
        .s_axis_a_tvalid (1'b1),
        .s_axis_b_tdata  (sum_stage5_reg[1]),
        .s_axis_b_tvalid (1'b1),
        .m_axis_result_tdata (sum_stage6),
        .m_axis_result_tvalid()
    );

    regn #(32) sum6_reg_inst (.clk(clk), .rst(rst), .en_reg(en), .d(sum_stage6), .q(sum_stage6_reg));
    assign y_out = sum_stage6_reg; // Final output
    // --------------------------
    // Scalable delayed 'done' signal based on log2(N)+1 pipeline depth
    // --------------------------
    localparam int PIPE_DEPTH = $clog2(N) + 1;
    logic [PIPE_DEPTH-1:0] done_pipeline;
    regn #(PIPE_DEPTH) done_delay (
        .clk(clk),
        .rst(rst),
        .en_reg(en),
        .d(done_pipeline[PIPE_DEPTH-2:0]),
        .q(done_pipeline)
    );

    always_ff @(posedge clk) begin
        if (rst)
            done_pipeline[0] <= 1'b0;
        else if (en)
            done_pipeline[0] <= start;
    end
    logic done_valid;
    assign done_valid = done_pipeline[PIPE_DEPTH-1];  // Valid flag from pipeline tail
    assign done = done_valid;
