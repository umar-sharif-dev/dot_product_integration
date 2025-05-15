module top_dot_product_engine (
    input  logic         clk,
    input  logic         rst,
    input  logic         rstn,
    input  logic         en,
    input  logic         start,
    input  logic [7:0]   weight_byte,

    // Shared write address and data
    input  logic [3:0]   x_wr_addr,     // shared among all BRAMs
    input  logic [31:0]  x_wr_data,
    input  logic [63:0]  x_wr_en,       // one-hot enable for 64 BRAMs

    output logic [31:0]  y_out,
    output logic         done
);

    logic [511:0] sipo_out;

    // 1. BRAMs for x_vector
    logic [31:0] x_vector [0:63];

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
                .dout  (x_vector[i]) // each BRAM gives one row vector
            );
        end
    endgenerate

    // 2. SIPO (8-bit to 512-bit)
    logic [511:0] A_row_packed;

    sipo #(
        .N(8),
        .M(64)
    ) sipo_inst (
        .clk (clk),
        .rst (rst),
        .en  (en),
        .din (weight_byte),
        .dout(sipo_out)
    );
    
    assign A_row_packed = (start) ? sipo_out : 0; 

    // 3. Dot Product Engine
    dot_product_engine #(
        .N(64)
    ) dpe_inst (
        .clk         (clk),
        .rstn        (rstn),
        .start       (start),
        .A_row_packed(A_row_packed),
        .x_vector    (x_vector),
        .y_out       (y_out),
        .done        (done)
    );

endmodule
