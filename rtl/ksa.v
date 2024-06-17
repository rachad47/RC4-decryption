module ksa (
    input logic CLOCK_50, // --Clock Pin
    input logic [3:0] KEY, // -- push button switches
    input logic [9:0] SW, // -- slider switches
    output logic [9:0] LEDR, // -- red LEDS
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5 
);

    logic clk, reset_n;
    logic [7:0] address, address_2, data, data_2, q, q_2;
    logic wren, wren_2;
    

    assign clk = CLOCK_50;
    assign reset_n = KEY[3];

    // working RAM
    s_memory s_memory_inst (
        .address(address),
        .clock(clk),
        .data(data),
        .wren(wren),
        .q(q)
    );

    s_memory s_memory_inst_2 (
        .address(address_2),
        .data(data_2),
        .clock(clk),
        .wren(wren_2),
        .q(q_2)
    );

    logic [7:0] q_m, q_m_2;
    logic [4:0] address_m, address_m_2;

    // encrypted message ROM
    message encrypted_message (
        .address(address_m),
        .clock(clk),
        .q(q_m)
    );

    message encrypted_message_2 (
        .address(address_m_2),
        .clock(clk),
        .q(q_m_2)
    );

    logic [4:0] address_d, address_d_2;
    logic [7:0] data_d, data_d_2;
    logic wren_d, wren_d_2;

    // decrypted message RAM
    decrypted_message write_decrypted_message (
        .clock(clk),
        .address(address_d),
        .data(data_d),
        .wren(wren_d),
        .q()
    );

    decrypted_message write_decrypted_message_2 (
        .clock(clk),
        .address(address_d_2),
        .data(data_d_2),
        .wren(wren_d_2),
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

    memory_handler memory_block_router_2 (
        .data_init(data_init_2),
        .data_shuffle(data_shuffle_2),
        .data_decrypt(data_decrypt_2),

        .wren_init(wen_init_2),
        .wren_shuffle(wen_shuffle_2),
        .wren_decrypt(wen_decrypt_2),
        
        .address_init(address_init_2),
        .address_shuffle(address_shuffle_2),
        .address_decrypt(address_decrypt_2),
        
        .mem_sel_init(memory_sel_init_2),
        .mem_sel_shuffle(memory_sel_shuffle_2),
        .mem_sel_decrypt(memory_sel_decrypt_2),
        
        .start_init(init_mem_handler_2),
        .start_shuffle(shuffle_mem_handler_2),
        .start_decrypt(decrypt_mem_handler_2),
        
        .output_data_shuffle(readdata_shuffle_2),
        .output_data_decrypt(readdata_decrypt_2),
        
        .q(q_2),
        .wren(wren_2),
        .address(address_2),
        .data(data_2),

        .wren_d(wren_d_2),
        .data_d(data_d_2),
        .address_d(address_d_2),
        
        .q_m(q_m_2),
        .address_m(address_m_2)
    );

    //FSM1 - Memory Initialization

    wire finish_init, init_mem_handler, wen_init;
    wire [7:0] data_init, address_init;
    logic [1:0] memory_sel_init;

    meme_init meme_init_inst (
        .clk(clk), .state_start(~KEY[3]  || reset_pulse ),  .start(SW[9]),
        .finish(finish_init),
        .init_mem_handler(init_mem_handler),
        .data(data_init),
        .address(address_init),
        .memory_sel(memory_sel_init),
        .wen(wen_init)
    );

    wire finish_init_2, init_mem_handler_2, wen_init_2;
    wire [7:0] data_init_2, address_init_2;
    logic [1:0] memory_sel_init_2;

    meme_init meme_init_inst_2 (
        .clk(clk), .state_start(~KEY[3] || reset_pulse_2 ), .start(SW[9]),
        .finish(finish_init_2),
        .init_mem_handler(init_mem_handler_2),
        .data(data_init_2),
        .address(address_init_2),
        .memory_sel(memory_sel_init_2),
        .wen(wen_init_2)
    );
    
    // FSM2 - initialization

    logic finish_shuffle, shuffle_mem_handler, wen_shuffle;
    logic [7:0] data_shuffle, address_shuffle, readdata_shuffle;
    logic [1:0] memory_sel_shuffle;
    
 wire [7:0]j;

    mem_shuffle memory_shuffle_inst (
        .clk(clk), .state_start(finish_init), .rst(~KEY[3] || reset_pulse), // reset butn is the same one as the start butn of mem_init
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

    logic finish_shuffle_2, shuffle_mem_handler_2, wen_shuffle_2;
    logic [7:0] data_shuffle_2, address_shuffle_2, readdata_shuffle_2;
    logic [1:0] memory_sel_shuffle_2;

    wire [7:0] j_2;

    mem_shuffle memory_shuffle_inst_2 (
        .clk(clk), .state_start(finish_init_2), .rst(~KEY[3] || reset_pulse_2), // reset butn is the same one as the start butn of mem_init
        .finish(finish_shuffle_2),
        .shuffle_mem_handler(shuffle_mem_handler_2),
        .data(data_shuffle_2),
        .address(address_shuffle_2),
        .memory_sel(memory_sel_shuffle_2),
        .wen(wen_shuffle_2),
      .secret_key({2'b0, counter_2}) ,
        // .secret_key(24'b01001001_00000010_00000000) ,
        .iterations(8'hFF),  
        // .q_data(readdata_shuffle)
        .q_data(q_2),
        .out_j(j_2)
    );


    // FSM3 INITIALIZATION

    logic [7:0] data_decrypt, readdata_decrypt, address_decrypt;
    logic finish_decrypt, wen_decrypt, decrypt_mem_handler;
    logic [1:0] memory_sel_decrypt;

    logic valid;
    mem_decrypt get_decrypted_message (
        .clk(clk),
        .start_sig(finish_shuffle),
        .reset(~KEY[3] || reset_pulse),
        .q_data(readdata_decrypt),
        .iterations(31),
        .finish(finish_decrypt),
        .other_finished(finish_decrypt_2),
        .decrypt_mem_handler(decrypt_mem_handler),
        .data(data_decrypt),
        .address(address_decrypt),
        .memory_sel(memory_sel_decrypt),
        .wen(wen_decrypt),
        .valid(valid) //added it to check the key
    );

    logic [7:0] data_decrypt_2, readdata_decrypt_2, address_decrypt_2;
    logic finish_decrypt_2, wen_decrypt_2, decrypt_mem_handler_2;
    logic [1:0] memory_sel_decrypt_2;
    logic valid_2;

    mem_decrypt get_decrypted_message_2 (
        .clk(clk),
        .start_sig(finish_shuffle_2),
        .reset(~KEY[3] || reset_pulse_2),
        .q_data(readdata_decrypt_2),
        .iterations(31),
        .finish(finish_decrypt_2),
        .other_finished(finish_decrypt),
        .decrypt_mem_handler(decrypt_mem_handler_2),
        .data(data_decrypt_2),
        .address(address_decrypt_2),
        .memory_sel(memory_sel_decrypt_2),
        .wen(wen_decrypt_2),
        .valid(valid_2) //added it to check the key
    );    

    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1 (
        .ssOut(HEX0),
        .nIn(counter[3:0])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2 (
        .ssOut(HEX1),
        .nIn(counter[7:4])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3 (
        .ssOut(HEX2),
        .nIn(counter[11:8])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4 (
        .ssOut(HEX3),
        .nIn(counter[15:12])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5 (
        .ssOut(HEX4),
        .nIn(counter[19:16])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst6 (
        .ssOut(HEX5),
        .nIn(counter[21:20])
    );

    assign LEDR[0]= valid || valid_2;
    
    logic reset_pulse;
    logic [21:0] counter;
    rc4_brute_force rc4_brute_force_inst (
        .clk(clk),
        .rst(~KEY[3]),
        .valid(valid),
        .finish_decrypt(finish_decrypt),
        .counter(counter),
        .init_val(22'd0),
        .reset_pulse(reset_pulse),
        .solved(LEDR[5])
    );

    logic reset_pulse_2;
    logic [21:0] counter_2;
    rc4_brute_force rc4_brute_force_inst_2 (
        .clk(clk),
        .rst(~KEY[3]),
        .valid(valid_2),
        .finish_decrypt(finish_decrypt_2),
        .counter(counter_2),
        .init_val(22'd1),
        .reset_pulse(reset_pulse_2),
        .solved(LEDR[4])
    );

endmodule