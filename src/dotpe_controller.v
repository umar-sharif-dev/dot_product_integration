// Dot Product Engine Controller
// Controls data sequencing for A input, multiplication, accumulation, and done signaling

module dotpe_controller (
    input  logic clk,
    input  logic rst,
    input  logic start_op,
    input  logic done_pipeline,     // asserted by datapath PIPE_DEPTH cycles after start
    output logic start,             // signal to start datapath
    output logic en,                // enable for pipelined registers
    output logic busy,              // high when operation is active
    output logic done               // final done flag for controller
);

    typedef enum logic [1:0] {
        IDLE,
        EXECUTE,
        WAIT_DONE,
        FINISH
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE:       if (start_op) next_state = EXECUTE;
            EXECUTE:    next_state = WAIT_DONE;
            WAIT_DONE:  if (done_pipeline) next_state = FINISH;
            FINISH:     next_state = IDLE;
        endcase
    end

    assign start = (state == EXECUTE);
    assign en    = (state == EXECUTE || state == WAIT_DONE);
    assign busy  = (state != IDLE);
    assign done  = (state == FINISH);

endmodule
