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
    output logic [4:0] address_decrypt_d,  //I changed that casue same name was declared above

    // for encrypted message ROM
    input logic [7:0] q_m,
    output logic [4:0] address_m
);
    
always_comb begin
    // Check if we are in init memory stage
    if (start_init) begin
        case (mem_sel_init)
            // WORKING RAM
            2'b01: begin
                // read from working RAM
                wren = wren_init;
                data = data_init;
                address = address_init;

                // Everything else is not used
                output_data_decrypt = 0;
                output_data_shuffle = 0;
                wren_d = 0;
                data_d = 0;
                address_decrypt_d = 0;
                address_m = 0;
            end 
            default: begin
                // SHOULD NEVER REACH HERE
                output_data_decrypt = 1'b0;
                output_data_shuffle = 1'b0;
                wren_d = 1'b0;
                data_d = 1'b0;
                address_decrypt_d = 1'b0;
                address_m = 1'b0;
                wren = 1'b0;
                data = 1'b0;
                address = 1'b0; 
            end
        endcase
    end
    // Check if we are in shuffle stage
    else if (start_shuffle) begin
        case (mem_sel_shuffle)
            // Working 
            2'b01: begin
                address = 0;
            end 
            default: address = 0;
        endcase
    end
end

endmodule