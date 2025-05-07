module intN_to_fp32_wrapper (
    input  logic        clk,
    input  logic        rstn,
    input  logic [2:0]  data_type,   // 3-bit select: 0=int2, 1=int4, 2=int8, 3=uint8, 4=fp16, 5=bf16
    input  logic [15:0] raw_data_in, // Holds any raw input type (only lower bits used per type)
    input  logic        start,
    output logic        ready,
    output logic [31:0] result,
    output logic        valid
);

    typedef enum logic [2:0] {
        INT2  = 3'd0,
        INT4  = 3'd1,
        INT8  = 3'd2,
        UINT8 = 3'd3,
        FP16  = 3'd4,
        BF16  = 3'd5
    } data_t;

    logic [31:0] fixed_data;
    logic        use_lookup;

    // ===============================
    // Fixed-point Pre-processing
    // ===============================
    always_comb begin
        use_lookup = 1'b0;
        case (data_type)
            INT2:   fixed_data = {{30{raw_data_in[1]}}, raw_data_in[1:0]};
            INT4:   fixed_data = {{28{raw_data_in[3]}}, raw_data_in[3:0]};
            INT8:   fixed_data = {{24{raw_data_in[7]}}, raw_data_in[7:0]};
            UINT8:  fixed_data = {24'b0, raw_data_in[7:0]};
            default: begin
                fixed_data = 32'd0;
                use_lookup = 1'b1;
            end
        endcase
    end

    // ===============================
    // Fixed-to-Float IP Instance
    // ===============================
    logic        ip_valid;
    logic        ip_ready;
    logic [31:0] ip_result;

    fixed_to_float_ip fixed2float_inst (
        .aclk                 (clk),
        .aresetn              (rstn),
        .s_axis_a_tvalid      (start & ~use_lookup),
        .s_axis_a_tready      (ip_ready),
        .s_axis_a_tdata       (fixed_data),
        .m_axis_result_tvalid (ip_valid),
        .m_axis_result_tready (1'b1),
        .m_axis_result_tdata  (ip_result)
    );

    // ===============================
    // Lookup-based conversion (FP16, BF16)
    // ===============================
    logic [31:0] alt_result;
    logic        alt_valid;

    always_comb begin
        alt_result = 32'd0;
        alt_valid  = 1'b0;
        if (use_lookup && start) begin
            case (data_type)
                FP16:  alt_result = fp16_to_fp32(raw_data_in[15:0]);
                BF16:  alt_result = {raw_data_in[15:0], 16'b0}; // simple zero-extend
                default: alt_result = 32'd0;
            endcase
            alt_valid = 1'b1;
        end
    end

    // ===============================
    // Output Mux
    // ===============================
    assign result = use_lookup ? alt_result : ip_result;
    assign valid  = use_lookup ? alt_valid  : ip_valid;
    assign ready  = ip_ready;

    // ===============================
    // FP16 → FP32 Conversion (optional soft logic)
    // ===============================
    function automatic logic [31:0] fp16_to_fp32(input logic [15:0] fp16_in);
        logic [4:0]  exp;
        logic [9:0]  mant;
        logic [31:0] fp32;

        begin
            fp32[31]    = fp16_in[15];          // sign
            fp32[30:23] = {fp16_in[14:10]} + 8'd112; // exponent bias adjust: 127 - 15 = 112
            fp32[22:13] = fp16_in[9:0];         // mantissa
            fp32[12:0]  = 13'd0;                // zero-extended
            return fp32;
        end
    endfunction

endmodule
