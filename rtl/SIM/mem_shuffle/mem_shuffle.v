module mem_shuffle (
    input logic clk, 
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
    logic [8:0] i, j; // i as internal signal
    
    localparam START = 4'b0000;
    localparam READ_i_SETUP = 4'b0001;
    localparam READ_i = 4'b0010;
    localparam ADD = 4'b0011;
    localparam READ_j_SETUP = 4'b0100;
    localparam READ_j = 4'b0101;
    localparam CHANGE_i_SETUP = 4'b0110;
    localparam CHANGE_i = 4'b0111;
    localparam CHANGE_j_SETUP = 4'b1000;
    localparam CHANGE_j = 4'b1001;
    localparam FINISH = 4'b1010;
    localparam TEST = 4'b1011;

    logic [3:0] state;
    logic [7:0] temp_i, temp_j;
    assign out_j = j; // new added

    always_ff @(posedge clk) begin
        if (state_start) begin
            state <= START;
            i <= 0;
            j <= 0;
            finish <= 0;
            shuffle_mem_handler <= 1;
            memory_sel <= 2'b01;
            wen <= 0;
        end else begin
            case (state)
                START: begin
                    state <= READ_i_SETUP;
                    address <= i;    //set address for i
                    // address <= 8'hAB;
                    memory_sel <= 2'b01;
                    wen <= 0;
                    shuffle_mem_handler <= 1;
                end
                READ_i_SETUP: begin
                    state <= READ_i;
                    wen <= 0;
                end
                READ_i: begin
                    state <= ADD;
                    temp_i <= q_data; // Capture value from i
                    wen <= 0;
                    shuffle_mem_handler <= 1;
                end
                ADD: begin
                    state <= TEST;
                    j <= (j + temp_i + secret_key[i % 24]) % 256;
                    wen <= 0; 
                    shuffle_mem_handler <= 1;
                end
                TEST: begin
                    state <= READ_j_SETUP;
                    address <= j; // Set address to j
                    wen <= 0; 
                    shuffle_mem_handler <= 1;
                end
                READ_j_SETUP: begin
                    state <= READ_j;
                    wen <= 0;
                end
                READ_j: begin
                    state <= CHANGE_i_SETUP;
                    temp_j <= q_data; // Capture value from j
                    shuffle_mem_handler <= 1;
                end
                CHANGE_i_SETUP: begin
                    state <= CHANGE_i;
                    address <= i;
                    // address <= 8'hAB;
                    wen <= 0;
                end
                CHANGE_i: begin
                    state <= CHANGE_j_SETUP;
                    data <= temp_j;
                    wen <= 1;
                end
                CHANGE_j_SETUP: begin
                    state <= CHANGE_j;
                    address <= j;
                    // address <= 8'hD1;
                    wen <= 0;
                end
                CHANGE_j: begin
                    state <= FINISH;
                    data <= temp_i;
                    wen <= 1;
                end
                FINISH: begin
                    wen <= 0;
                    if (i == iterations) begin
                        finish <= 1;
                        shuffle_mem_handler <= 0;
                        memory_sel <= 2'b00;
                    end else begin
                        state <= START;
                        i <= i + 1;
                        finish <= 0;
                    end
                end
            endcase
        end
    end

endmodule
