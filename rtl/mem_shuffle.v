module mem_shuffle (
    input logic clk, 
    input logic state_start
    input logic [23:0] secret_key,
    input logic [7:0] q_data,

    output logic finish, shuffle_mem_handler,
    output logic [7:0] data,
    output logic [7:0] address,
    output logic [1:0] memory_sel,
    output logic wen
);
    logic [8:0] i,j; // i as internal signal
    
    localparam START = 3b'1_00;
    localparam SHUFFLE = 3b'1_01;
    localparam FINISH = 3b'0_10;

    logic [2:0] state;
    assign shuffle_mem_handler = state[2];
    logic [7:0] temp_i, temp_j;


    always_ff @(posedge clk) begin
        case (state)
            START: begin
                i <= 9'h00;
                j <= 9'h00;
                shuffle_mem_handler <= 1;
                memory_sel <= 2'b01;
                finish <= 0;
                state <= SHUFFLE;
            end
            SHUFFLE: begin
                if (i == 9'h100) begin
                    state <= FINISH;
                end else begin
                    address <= i;
                    temp_i <= q_data;
                    j <= j + temp + secret_key[i % 24];
                    // swap 
                    wen <= 1;
                    address <= j;
                    temp_j <= q_data;
                    data <= temp_i;
                    address <= i;
                    data <= temp_j;
                    i <= i + 1;
                    
                end
            end
            FINISH: begin
                finish <= 1;
                wen <= 0;
                shuffle_mem_handler <= 0;
                memory_sel <= 2'b00;
            end
        endcase
    end
    


endmodule