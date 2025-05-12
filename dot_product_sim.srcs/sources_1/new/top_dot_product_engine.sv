`timescale 1ns/1ps
module top_dot_product_engine (
    input  logic         clk,
    input  logic         rst,
    input  logic         rstn,
    input  logic         en,
    input  logic         start,
    input  logic [15:0]  weight_element,
    input  logic [2:0]   data_type,

    input  logic [3:0]   x_wr_addr,
    input  logic [31:0]  x_wr_data,
    input  logic [63:0]  x_wr_en,

    output logic [31:0]  y_out,
    output logic         done
);

    localparam MAX_N = 128;

    // 1. BRAMs for x_vector
    logic [31:0] x_vector [0:MAX_N-1];
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin : GEN_X_BRAMS
            block_ram #(
                .ADDR_WIDTH(4),
                .DATA_WIDTH(32)
            ) bram_inst (
                .clk   (clk),
                .addr  (x_wr_addr),
                .wr_en (x_wr_en[i]),
                .din   (x_wr_data),
                .dout  (x_vector[i])
            );
        end
        for (i = 64; i < MAX_N; i++) begin : GEN_UNUSED_BRAMS
            assign x_vector[i] = 32'd0;
        end
    endgenerate

    // 2. Determine shift width based on data_type
    logic [7:0] shift_width;
    always_comb begin
        case (data_type)
            3'd0: shift_width = 2;
            3'd1: shift_width = 4;
            3'd2, 3'd3: shift_width = 8;
            3'd4, 3'd5: shift_width = 16;
            default: shift_width = 8;
        endcase
    end

    // 3. Dynamic SIPO to pack weights
    logic [MAX_N*2-1:0] A_row_packed;
    dynamic_sipo #(MAX_N*2) dyn_sipo_inst (
        .clk   (clk),
        .rst   (rst),
        .en    (en),
        .din   (weight_element),
        .shift (shift_width),
        .dout  (A_row_packed)
    );

    // 4. Dot Product Engine
    dot_product_engine #(
        .MAX_N(MAX_N),
        .DATA_WIDTH(32)
    ) dpe_inst (
        .clk         (clk),
        .rstn        (rstn),
        .start       (start),
        .data_type   (data_type),
        .shift_width (shift_width),
        .A_row_packed(A_row_packed),
        .x_vector    (x_vector),
        .y_out       (y_out),
        .done        (done)
    );

endmodule
