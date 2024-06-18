module rc4_brute_force(
    input logic clk,
    input logic rst,
    input logic valid,
    input logic [21:0] init_val,
    input logic [7:0] core_count,
    input logic finish_decrypt, 
    input logic stop_all,
    output logic reset_pulse,
    output logic solved,
    output logic [21:0] counter,
    output logic [21:0] solved_counter
);

// State definitions
localparam START        = 3'b000;
localparam CHECK_FINISH = 3'b001;
localparam CHECK_VALID  = 3'b010;
localparam CHECK_STOP   = 3'b011;
localparam INCREMENT    = 3'b100;
localparam FINISH       = 3'b101;
localparam CRACKED      = 3'b110;

logic [2:0] state;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= START;
        reset_pulse <= 0;
        counter <= init_val;
        solved <= 0;
        solved_counter <= 0;
    end else begin
        case (state)
            START: begin
                state <= CHECK_FINISH;
                reset_pulse <= 0;
                solved_counter <= 0;
            end

            CHECK_FINISH: begin
                if (finish_decrypt) begin
                    state <= CHECK_VALID;
                end else begin
                    state <= START;
                end
            end

            CHECK_VALID: begin
                if (valid) begin
                    state <= CHECK_STOP;
                end else begin
                    state <= INCREMENT;
                end
            end

            CHECK_STOP: begin
                if (stop_all) begin
                    solved_counter <= 0;
                    state <= START;
                end else begin
                    state <= CRACKED;
                end
            end

            INCREMENT: begin
                counter <= counter + core_count;
                state <= FINISH;
                reset_pulse <= 1;
                solved_counter <= 0;
            end

            FINISH: begin
                state <= START;
                reset_pulse <= 0;
                solved_counter <= 0;
            end

            CRACKED: begin
                state <= CRACKED;
                reset_pulse <= 0;
                solved <= 1;
                solved_counter <= counter;
            end

            default: state <= START;
        endcase
    end
end

endmodule
