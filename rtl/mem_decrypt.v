module mem_decrypt (
    input clk,
    input start,
    input reset,
    input logic [23:0] secret_key,
    input logic [7:0] q_data,

    output logic finish, decrypt_mem_handler,
    output logic [7:0] data,
    output logic [7:0] address,
    output logic [1:0] memory_sel,
    output logic wen
);

// counter signals
logic [8:0] i, j, temp_i, temp_j;

// state declarations: finish, decrypt_mem_handler, and wen are encoded in the states 

parameter idle = 7'b0000_000;
parameter increment_j = 7'b0001_010; 
parameter read_at_i = 7'b0010_010;
parameter read_at_j = 7'b0011_010;
parameter write_at_i = 7'b0100_011;
parameter write_at_j = 7'b0101_011;
parameter add_si_sj = 7'b0110_010;
parameter read_sum = 7'b0111_010;
parameter read_encrypted_k = 7'b1000_010;
parameter write_decypted_k = 7'b1001_011;
parameter increment_k = 7'b1010_010;
parameter increment_i = 7'b1011_010;
parameter finished = 7'b1100_110;
parameter start = 7'b1101_000;
parameter read_at_i_2 = 7'b1111_000;
parameter read_at_j_2 = 7'b1111_001;
parameter read_sum_2 = 7'b1111_010;
parameter read_encrypted_k_2 = 7'b1111_011;

logic [6:0] state, next_state;
logic [5:0] k; 

// state controller
always_ff @ (posedge clk, posedge reset ) begin
    if (reset) state <= idle;
    else       state <= next_state;
end

// next_state logic
always_comb begin
    case (state)
        idle: begin
            if (start) next_state = start;
            else       next_state = idle;
        end 
        start: next_state = increment_i;
        increment_i: next_state = increment_j;
        increment_j: next_state = read_at_i;
        read_at_i: next_state = read_at_i_2;
        read_at_i_2: next_state = read_at_j
        read_at_j: next_state = read_at_j_2;
        read_at_j_2: next_state = write_at_i;
        write_at_i: next_state = write_at_j;
        write_at_j: next_state = add_si_sj;
        add_si_sj: next_state = read_sum;
        read_sum: next_state = read_sum_2;
        read_sum_2: next_state = read_encrypted_k;
        read_encrypted_k: next_state = read_encrypted_k_2;
        read_encrypted_k_2: next_state = write_decypted_k;
        write_decypted_k: begin
            if (k == 32) next_state = idle;
            else         next_state = increment_k;
        increment_k: next_state = start;
        end
        default: next_state = idle;
    endcase
end

// encode the outputs in a flip flop
logic [7:0] i, j, temp_i, temp_j;

always_ff @ (posedge clk) begin
    case (state)
        idle: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 0;
            memory_sel <= 0;
            address <= 0;
            i <= 0;
            j <= 0;
            k <= 0;
        end
        start: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 0;
            address <= 0;
            i <= i;
            j <= j;
            k <= k;
        end
        increment_i: begin
            // i = i + 1
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 0;
            address <= 0;
            i <= i + 1;
            j <= 0;
            k <= 0;
        end
        increment_j: begin
            // j = j + 1
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 0;
            address <= 0;
            i <= i;
            j <= j + 1;
            k <= k;
        end
        read_at_i: begin
            // get s[i] for swap (takes 2 cycles)
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;
            i <= i;
            j <= j;
            k <= k;

            // scratch register to store s[i]
            temp_i <=  q_data;
        end
        read_at_i_2: begin
            // get s[i] for swap (second cycle)
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;
            i <= i;
            j <= j;
            k <= k;

            // scratch register to store s[i]
            temp_i <= q_data;
        end
        read_at_j: begin
           // get s[j] for swap (takes 2 cycles)
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= j;
            i <= i;
            j <= j;
            k <= k; 

            // scratch registers
            temp_i <= temp_i;
            temp_j <= q_data;
        end
        read_at_j_2: begin
            // get s[j] for swap (takes 2 cycles)
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= j;
            i <= i;
            j <= j;
            k <= k; 

            // scratch registers
            temp_i <= temp_i;
            temp_j <= q_data;
        end
        write_at_i: begin
            // write s[j] to addr i
            wen <= 1;
            data <= temp_j;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;
            i <= i;
            j <= j;
            k <= k; 

            // scratch registers
            temp_i <= temp_i;
            temp_j <= temp_j;
        end
    endcase
end
    
endmodule