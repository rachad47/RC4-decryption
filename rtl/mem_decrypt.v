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

logic [6:0] state, next_state;

assign finish = state[2];
assign decrypt_mem_handler = state[1];
assign wen = state[0];

always_ff @ (posedge clk, posedge reset ) begin
    if (reset) state <= idle;
    else       state <= next_state;
end
    
endmodule