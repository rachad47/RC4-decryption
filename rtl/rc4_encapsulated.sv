module rc4_encapsulated (
    input logic clk,
    input logic reset,
    input logic start,
    input logic stop_all,
    input logic [7:0] core_init_val,
    input logic [7:0] total_cores,
    output logic [21:0] secret_key, in_progress,
    output logic correct_key_found
);

    logic [7:0] address, data, q;
    logic wren;


    // working RAM
    s_memory s_memory_inst (
        .address(address),
        .clock(clk),
        .data(data),
        .wren(wren),
        .q(q)
    );

    logic [7:0] q_m;
    logic [4:0] address_m;

    // encrypted message ROM
    message encrypted_message (
        .address(address_m),
        .clock(clk),
        .q(q_m)
    );

    logic [4:0] address_d;
    logic [7:0] data_d;
    logic wren_d;

    // decrypted message RAM
    decrypted_message write_decrypted_message (
        .clock(clk),
        .address(address_d),
        .data(data_d),
        .wren(wren_d),
        .q()
    );

    memory_handler memory_block_router (
        .data_init(data_init),
        .data_shuffle(data_shuffle),
        .data_decrypt(data_decrypt),

        .wren_init(wen_init),
        .wren_shuffle(wen_shuffle),
        .wren_decrypt(wen_decrypt),
        
        .address_init(address_init),
        .address_shuffle(address_shuffle),
        .address_decrypt(address_decrypt),
        
        .mem_sel_init(memory_sel_init),
        .mem_sel_shuffle(memory_sel_shuffle),
        .mem_sel_decrypt(memory_sel_decrypt),
        
        .start_init(init_mem_handler),
        .start_shuffle(shuffle_mem_handler),
        .start_decrypt(decrypt_mem_handler),
        
        .output_data_shuffle(readdata_shuffle),
        .output_data_decrypt(readdata_decrypt),
        
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

    //FSM1 - Memory Initialization

    wire finish_init, init_mem_handler, wen_init;
    wire [7:0] data_init, address_init;
    logic [1:0] memory_sel_init;

    meme_init meme_init_inst (
        .clk(clk), .state_start(reset  || reset_pulse ),  .start(start),
        .finish(finish_init),
        .init_mem_handler(init_mem_handler),
        .data(data_init),
        .address(address_init),
        .memory_sel(memory_sel_init),
        .wen(wen_init)
    );
    
    // FSM2 - initialization

    logic finish_shuffle, shuffle_mem_handler, wen_shuffle;
    logic [7:0] data_shuffle, address_shuffle, readdata_shuffle;
    logic [1:0] memory_sel_shuffle;
    
 wire [7:0]j;

    mem_shuffle memory_shuffle_inst (
        .clk(clk), .state_start(finish_init), .rst(reset || reset_pulse), // reset butn is the same one as the start butn of mem_init
        .finish(finish_shuffle),
        .shuffle_mem_handler(shuffle_mem_handler),
        .data(data_shuffle),
        .address(address_shuffle),
        .memory_sel(memory_sel_shuffle),
        .wen(wen_shuffle),
      .secret_key({2'b0, counter}) ,
        // .secret_key(24'b01001001_00000010_00000000) ,
        .iterations(8'hFF),  
        // .q_data(readdata_shuffle)
        .q_data(q),
        .out_j(j)
    );


    // FSM3 INITIALIZATION

    logic [7:0] data_decrypt, readdata_decrypt, address_decrypt;
    logic finish_decrypt, wen_decrypt, decrypt_mem_handler;
    logic [1:0] memory_sel_decrypt;

    logic valid;
    mem_decrypt get_decrypted_message (
        .clk(clk),
        .start_sig(finish_shuffle),
        .reset(reset || reset_pulse),
        .q_data(readdata_decrypt),
        .iterations(31),
        .finish(finish_decrypt),
        .other_finished(stop_all),
        .decrypt_mem_handler(decrypt_mem_handler),
        .data(data_decrypt),
        .address(address_decrypt),
        .memory_sel(memory_sel_decrypt),
        .wen(wen_decrypt),
        .valid(valid) //added it to check the key
    );

    logic reset_pulse;
    logic [21:0] counter, solved_counter;
    rc4_brute_force rc4_brute_force_inst (
        .clk(clk),
        .rst(reset),
        .valid(valid),
        .finish_decrypt(finish_decrypt),
        .counter(counter),
        .solved_counter(solved_counter),
        .init_val(core_init_val),
        .core_count(total_cores),
        .reset_pulse(reset_pulse),
        .solved(solved),
        .stop_all(stop_all)
    );

    logic solved;

    

    assign correct_key_found = solved;
    assign secret_key = solved_counter;
    assign in_progress = counter;
    
endmodule