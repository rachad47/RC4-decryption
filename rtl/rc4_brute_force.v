module rc4_brute_force(
    input logic clk,
    input logic rst,
    input logic valid,
    input logic [21:0] init_val,
    input logic [7:0] core_count,
    input logic finish_decrypt,
    output logic reset_pulse,
    output logic solved,
    output logic [21:0] counter
);

localparam START = 2'b00;
localparam INCREMENT= 2'b01;
localparam FINISH = 2'b10;
localparam CRACKED = 2'b11;

logic [1:0] state;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= START;
        reset_pulse <= 0;
        counter <= init_val; // was 0
        solved <= 0;

    end else begin
        case (state)
            START: begin
                if (finish_decrypt) begin
                  if (valid) begin
                    state <= CRACKED;
                    reset_pulse <= 0;
                   end
                   else begin
                    state <= INCREMENT;
                    reset_pulse <= 0;
                    counter <= counter + core_count; // was counter + 1
                   end
                end 
                else begin
                    state <= START;
                    reset_pulse <= 0;
                end
            end

            CRACKED: begin
                state <= CRACKED;
                reset_pulse <= 0;
                solved <= 1;
            end
            INCREMENT: begin
                state <= FINISH;
                reset_pulse <= 1;
            end
            FINISH: begin
                state <= START;
                reset_pulse <= 0;
            end
            default: state <= START;
        endcase
    end
end

endmodule