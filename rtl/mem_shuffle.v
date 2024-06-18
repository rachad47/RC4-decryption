module mem_shuffle (
    input logic clk, 
    input logic rst,  // Added reset signal
    input logic state_start,
    input logic [23:0] secret_key,
    input logic [7:0] q_data,
    input logic [9:0] iterations,
    output logic finish, shuffle_mem_handler,
    output logic [7:0] data,
    output logic [7:0] address,
    output logic [1:0] memory_sel,
    output logic wen,
    output logic [7:0] out_j
);

    logic [7:0] i, j; // Internal signals for indices

    // State encoding using local parameters
    localparam START = 4'b0000;
    localparam READ_I_SETUP = 4'b0001;
    localparam READ_I = 4'b0010;
    localparam ADD = 4'b0011;
    localparam READ_J_SETUP = 4'b0100;
    localparam READ_J = 4'b0101;
    localparam CHANGE_I_SETUP = 4'b0110;
    localparam CHANGE_I = 4'b0111;
    localparam CHANGE_J_SETUP = 4'b1000;
    localparam CHANGE_J = 4'b1001;
    localparam FINISH = 4'b1010;
    localparam TEST = 4'b1011;
    localparam IDLE = 4'b1100;

    logic [3:0] state  /* synthesis keep */;

    logic [7:0] temp_i, temp_j;

    // Output assignment
    assign out_j = j;

    // Secret key bytes extraction
    logic [7:0] secret_key_bytes [2:0];
    assign secret_key_bytes[0] = secret_key[23:16];
    assign secret_key_bytes[1] = secret_key[15:8];
    assign secret_key_bytes[2] = secret_key[7:0];

    // State machine
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset state
            state <= IDLE;
            i <= 0;
            j <= 0;
            finish <= 0;
            shuffle_mem_handler <= 0;
            memory_sel <= 2'b00;
            wen <= 0;
        
        end else begin
            case (state)
                // waiting state
                IDLE: begin
                    state <= state_start ? START : IDLE;
                    i <= 0;
                    j <= 0;
                    finish <= 0;
                    shuffle_mem_handler <= 0;
                    memory_sel <= 2'b00;
                    wen <= 0;
                end
                START: begin
                    // Set up to read i
                    state <= READ_I_SETUP;
                    address <= i;
                    memory_sel <= 2'b01;
                    wen <= 0;
                    shuffle_mem_handler <= 1;
                end
                READ_I_SETUP: begin
                    state <= READ_I;
                end
                READ_I: begin
                    // Capture value from i
                    temp_i <= q_data;
                    state <= ADD;
                end
                ADD: begin
                    // Calculate j
                    j <= j + temp_i + secret_key_bytes[i % 3];
                    state <= TEST;
                end
                TEST: begin
                    // Set up to read j
                    state <= READ_J_SETUP;
                    address <= j;
                end
                READ_J_SETUP: begin
                    state <= READ_J;
                end
                READ_J: begin
                    // Capture value from j
                    temp_j <= q_data;
                    state <= CHANGE_I_SETUP;
                end
                CHANGE_I_SETUP: begin
                    // Set up to change i
                    state <= CHANGE_I;
                    address <= i;
                end
                CHANGE_I: begin
                    // Write value to i
                    data <= temp_j;
                    wen <= 1;
                    state <= CHANGE_J_SETUP;
                end
                CHANGE_J_SETUP: begin
                    // Set up to change j
                    state <= CHANGE_J;
                    address <= j;
                end
                CHANGE_J: begin
                    // Write value to j
                    data <= temp_i;
                    wen <= 1;
                    state <= FINISH;
                end
                FINISH: begin
                    // Finish the current iteration
                    wen <= 0;
                    if (i == iterations) begin
                        finish <= 1;
                        shuffle_mem_handler <= 0;
                        memory_sel <= 2'b00;
                    end else begin
                        state <= START;
                        i <= i + 1;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
