module memory_handler (
    // memory arguments provided by each state machine
    input logic [7:0] data_init,
    input logic [7:0] data_shuffle,
    input logic [7:0] data_decrypt,

    input logic wren_init,
    input logic wren_shuffle,
    input logic wren_decrypt,

    input logic [7:0] address_init,
    input logic [7:0] address_shuffle,
    input logic [7:0] address_decrypt,

    input logic [1:0] mem_sel_init,
    input logic [1:0] mem_sel_shuffle,
    input logic [1:0] mem_sel_decrypt,

    // indicators of what state machine is running
    input logic start_init, 
    input logic start_shuffle, 
    input logic start_decrypt,

    // output the read data from memory
    output logic [7:0] output_data_shuffle, 
    output logic [7:0] output_data_decrypt,

    // interface signals to each memory unit  
    // for working memory
    input logic [7:0] q,
    output logic wren,
    output logic [7:0] address, 
    output logic [7:0] data,

    // for decrypted message RAM
    output logic wren_d,
    output logic [7:0] data_d,
    output logic [4:0] address_decrypt,

    // for encrypted message ROM
    input logic [7:0] q_m,
    output logic [4:0] address_m,
);
    
always_comb begin
    if (wren_init) begin
        case (mem_sel_init)
            2'b01: begin
                wren = wren_init;
                data = data_init;
                address = address_init;
                output_data_decrypt = 0;
                output_data_decrypt = 0;
                wren_d = 0;
                data_d = 0;
                address_decrypt = 0;
                address_m = 0;
            end 
            default: 
        endcase
    end
end

endmodule