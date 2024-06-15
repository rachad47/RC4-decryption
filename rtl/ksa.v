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
    logic [7:0] address, data, q;
    logic wren;
    

    assign clk = CLOCK_50;
    assign reset_n = KEY[3];

    s_memory s_memory_inst (
        .address(address),
        .clock(CLOCK_50),
        .data(data),
        .wren(wren),
        .q(q)
    );

    memory_handler memory_block_router (
        .data_init(data_init),
        .data_shuffle(data_shuffle),
        .data_decrypt(),

        .wren_init(wen_init),
        .wren_shuffle(wen_shuffle),
        .wren_decrypt(),
        
        .address_init(address_init),
        .address_shuffle(address_shuffle),
        .address_decrypt(),
        
        .mem_sel_init(memory_sel_init),
        .mem_sel_shuffle(memory_sel_shuffle),
        .mem_sel_decrypt(),
        
        .start_init(init_mem_handler),
        .start_shuffle(shuffle_mem_handler),
        .start_decrypt(),
        
        .output_data_shuffle(readdata_shuffle),
        .output_data_decrypt(),
        
        .q(q),
        .wren(wren),
        .address(address),
        .data(data),

        .wren_d(),
        .data_d(),
        .address_d(),
        
        .q_m(),
        .address_m()
    );

    //FSM1 - Memory Initialization

    wire finish_init, init_mem_handler, wen_init;
    wire [7:0] data_init, address_init;
    logic [1:0] memory_sel_init;

    meme_init meme_init_inst (
        .clk(clk), .state_start(~KEY[3]),  
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
        .clk(clk), .state_start(finish_init), .rst(~KEY[3]), // reset butn is the same one as the start butn of mem_init
        .finish(finish_shuffle),
        .shuffle_mem_handler(shuffle_mem_handler),
        .data(data_shuffle),
        .address(address_shuffle),
        .memory_sel(memory_sel_shuffle),
        .wen(wen_shuffle),
      .secret_key(24'b00000000_00000010_01001001) ,
        // .secret_key(24'b01001001_00000010_00000000) ,
        .iterations(SW[8:0]),  
        // .q_data(readdata_shuffle)
        .q_data(q),
        .out_j(j)
    );

    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1 (
        .ssOut(HEX0),
        .nIn(j[3:0])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2 (
        .ssOut(HEX1),
        .nIn(j[7:4])
    );


endmodule