module mem_decrypt (
    input clk,
    input start_sig,
    input reset,
    input logic [7:0] q_data,
    input logic [4:0] iterations,
    input logic other_finished, // if another core finished

    output logic finish, decrypt_mem_handler,
    output logic [7:0] data,
    output logic [7:0] address,
    output logic [1:0] memory_sel,
    output logic wen,
    output logic valid
);

// i, j, and k ar variables
// temp_i and temp_j are used to store s[i] and s[j]
// f is used to store s[s[i] + s[j]]
// temp_k is sued to store encrypted_input[k]
logic [7:0] i, j, temp_i, temp_j;
logic [5:0] k;
logic [7:0] f, temp_k;

logic [7:0] result;

// state declarations: finish, decrypt_mem_handler, and wen are encoded in the states 

typedef enum logic [4:0] {
    idle,
    start, 
    increment_i,
    setup_read_i,
    read_i,
    sample_i,
    add_to_j,
    setup_read_j,
    read_j,
    sample_j,
    write_to_i,
    write_to_j,
    setup_read_sum,
    read_sum,
    sample_sum,
    setup_k,
    read_k,
    sample_k,
    write_output,
    finished,
    increment_k
} statetype;

statetype state, next_state;

// state controller
always_ff @ (posedge clk, posedge reset ) begin
    if (reset) state <= idle;
    else       state <= next_state;
end

// next_state logic
always_comb begin
    case (state)
        // we check if we should start decrypting
        idle: begin
            if (start_sig) next_state = start;
            else       next_state = idle;
        end 
        // setup for memory_handler to take in input args from this fsm
        start: next_state = increment_i;

        // i = i + 1
        increment_i: next_state = setup_read_i;

        // states for getting s[i] from memory
        setup_read_i: next_state = read_i;
        read_i: next_state = sample_i;
        sample_i: next_state =  add_to_j; // was add_to_j

        // j = j + s[i]
        add_to_j: next_state = setup_read_j;

        // states for getting s[j] from memory
        setup_read_j: next_state = read_j;
        read_j: next_state = sample_j;
        sample_j: next_state = write_to_i;

        // swap s[i] and s[j]
        write_to_i: next_state = write_to_j;
        write_to_j: next_state = setup_read_sum; // was setup_read_sum

        // states for getting s[s[i] + s[j]] from memory
        setup_read_sum: next_state = read_sum;
        read_sum: next_state = sample_sum;
        sample_sum: next_state = setup_k;

        // states for getting encrypted_input[k]
        setup_k: next_state = read_k;
        read_k: next_state = sample_k;
        sample_k: next_state = write_output;

        // writing to decyprted_ouput
        // if k = 31, we are done, otherwise loop again
        write_output: begin
            if (k == iterations) next_state = finished;
            else         next_state = increment_k; 
        end     

        // k++;
        increment_k: next_state  = (valid && (~other_finished)) ? increment_i : finished; // added
        finished: next_state = finished;
        default: next_state = idle;
    endcase
end

// Outputs
always_ff @ (posedge clk) begin
    case (state)
        idle: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 0;
            memory_sel <= 0;
            address <= 0;
        end
        // initialize i and j to 0
        start: begin
            result <= 0;
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 0;
            address <= 0;

            i <= 0;
            j <= 0;
            k <= 0;
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
        end
        // get s[i]
        setup_read_i: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;
        end
        read_i: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;
        end
        // load s[i] into register
        sample_i: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;

            temp_i <= q_data;
        end
        // j = j + s[i]
        add_to_j: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 0;
            address <= 0;

            j <= j + temp_i;
        end
        // get s[j]
        setup_read_j: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= j;
        end
        read_j: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= j;
        end
        sample_j: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= j;

            temp_j <= q_data;
        end
        // s[i] = temp_j
        write_to_i: begin
            wen <= 1;
            data <= temp_j;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= i;
            
            temp_j <= temp_j;
        end
        // s[j] = temp_i
        write_to_j: begin
            wen <= 1;
            data <= temp_i;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= j;
        end
        // get s[s[i] + s[j]]
        setup_read_sum: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= temp_i + temp_j;
        end
        read_sum: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= temp_i + temp_j;
        end
        // f = s[s[i] + s[j]]
        sample_sum: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 1;
            address <= temp_i + temp_j;

            f <= q_data;
        end
        // get encrypted_output[k]
        setup_k: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 2;
            address <= k;
        end
        read_k: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 2;
            address <= k;
        end
        sample_k: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 2;
            address <= k;

            temp_k <= q_data;
        end
        // decrypted_output[k] = f XOR encrypted_output[k]
        write_output: begin
            wen <= 1;
            data <= f ^ temp_k;
            result <= f ^ temp_k;  //added
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 3;
            address <= k;

            temp_k <= temp_k;
        end
        // k++
        increment_k: begin
            wen <= 0;
            data <= 0;
            finish <= 0;
            decrypt_mem_handler <= 1;
            memory_sel <= 0;
            address <= 0;
            
            k <= k + 1;
        end
        finished: begin
            wen <= 0;
            data <= 0;
            finish <= 1;
            decrypt_mem_handler <= 0;
            memory_sel <= 0;
            address <= 0;
        end
    endcase
end


assign valid= ((result > 96) && (result < 123)) || (result == 32) ; 

    
endmodule