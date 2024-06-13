`timescale 1ns/1ps
module test_memory_handler ();

    logic [7:0] data_init;  
    logic [7:0] data_shuffle;
    logic [7:0] data_decrypt;

    logic wren_init;
    logic wren_shuffle;
    logic wren_decrypt;

    logic [7:0] address_init;
    logic [7:0] address_shuffle;
    logic [7:0] address_decrypt;

    logic [1:0] mem_sel_init;
    logic [1:0] mem_sel_shuffle;
    logic [1:0] mem_sel_decrypt;

    // indicators of what state machine is running
    logic start_init; 
    logic start_shuffle; 
    logic start_decrypt;

    // output the read data from memory
    logic [7:0] output_data_shuffle; 
    logic [7:0] output_data_decrypt;

    // interface signals to each memory unit  
    // for working memory
    logic [7:0] q;
    logic wren;
    logic [7:0] address; 
    logic [7:0] data;

    // for decrypted message RAM
    logic wren_d;
    logic [7:0] data_d;
    logic [4:0] address_d;  //I changed that casue same name was declared above

    // for encrypted message ROM
    logic [7:0] q_m;
    logic [4:0] address_m;

    memory_handler DUT (
        .data_init(data_init),
        .data_shuffle(data_shuffle),
        .data_decrypt(data_decrypt),

        .wren_init(wren_init),
        .wren_shuffle(wren_shuffle),
        .wren_decrypt(wren_decrypt),
        
        .address_init(address_init),
        .address_shuffle(address_shuffle),
        .address_decrypt(address_decrypt),
        
        .mem_sel_init(mem_sel_init),
        .mem_sel_shuffle(mem_sel_shuffle),
        .mem_sel_decrypt(mem_sel_decrypt),
        
        .start_init(start_init),
        .start_shuffle(start_shuffle),
        .start_decrypt(start_decrypt),
        
        .output_data_shuffle(output_data_shuffle),
        .output_data_decrypt(output_data_decrypt),
        
        .q(q),
        .wren(wren),
        .address(address),
        .data(data),

        .wren_d(wren_d),
        .data_d(data_d),
        .address_d(address_d),
        
        .q_m(q_m),
        .address_m(address_m)
    );

    initial begin
        q = 1; q_m = 2; 
        #10;

        // test start init 
        start_init = 1; start_shuffle = 0; start_decrypt = 0; #10;
        mem_sel_init = 1; address_init = 255; wren_init = 1; #10;

        // test mem_init
        start_init = 0; start_shuffle = 1; start_decrypt = 0; #10;
        mem_sel_shuffle = 1; address_shuffle = 255; wren_shuffle = 1; #10;
        wren_shuffle = 0; #10;

        // test mem_decrypt
        start_init = 0; start_shuffle = 0; start_decrypt = 1; #10;
        mem_sel_decrypt = 1; address_decrypt = 10; wren_decrypt = 1; #10;
        mem_sel_decrypt = 2; #10;
        mem_sel_decrypt = 3; #10;

        start_init = 0; start_shuffle = 0; start_decrypt = 0; #10;
    
        $stop;

    end

endmodule