module mem_shuffle (
    input logic clk, 
    input logic state_start,
    input logic [23:0] secret_key,
    input logic [7:0] q_data,
    output logic finish, shuffle_mem_handler,
    output logic [7:0] data,
    output logic [7:0] address,
    output logic [1:0] memory_sel,
    output logic wen
);
    logic [8:0] i,j; // i as internal signal
    
    localparam START = 3'b000;
    localparam READ_i = 3'b001;
    localparam ADD = 3'b010;
    localparam READ_j = 3'b011;
    localparam CHANGE_i = 3'b100;       //CHANGE_i & CHANGE_j for SWAP
    localparam CHANGE_j = 3'b101;
    localparam FINISH = 3'b110;

    logic [2:0] state;
    logic [7:0] temp_i, temp_j;

    always_ff @(posedge clk) begin
        if (state_start) begin
            state <= START;
            i <= 0;
            j <= 0;
        end else begin
            case (state)
                START: begin
                    state <= READ_i;
                    address <= i;
                    memory_sel <= 2'b01;
                    wen <= 0;
                    shuffle_mem_handler <= 1;
                end
                READ_i: begin
                    state <= ADD;
                    address <= i;
                    temp_i <= q_data;
                    wen <= 0;
                    shuffle_mem_handler <= 1;
                end
                ADD: begin
                    state <= READ_j;
                    j <= j + temp_i + secret_key[i%24];
                    wen <= 0; 
                    shuffle_mem_handler <= 1;
                end
                READ_j: begin
                    state <= CHANGE_i;
                    address <= j;
                    temp_j <= q_data;
                    shuffle_mem_handler <= 1;
                end
                CHANGE_i: begin
                    state <= CHANGE_j;
                    address <= i;
                    data <= temp_j;
                    wen <= 1;
                    shuffle_mem_handler <= 1;

                end
                CHANGE_j: begin
                    state <= FINISH;
                    address <= j;
                    data <= temp_i;
                    wen <= 1;
                    shuffle_mem_handler <= 1;

                end
                FINISH: begin
                    if (i == 255) begin
                        finish <= 1;
                        shuffle_mem_handler <= 0;
                        memory_sel <= 2'b00;
                        wen <= 0; 
                        shuffle_mem_handler <= 0;
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