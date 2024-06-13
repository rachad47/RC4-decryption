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

    assign clk = CLOCK_50;
    assign reset_n = KEY[3];

    s_memory s_memory_inst (
        .address(address),
        .clock(CLOCK_50),
        .data(data),
        .wren(wen),
        .q()
    );

    //FSM1 - Memory Initialization

    wire finish, init_mem_handler,wen;
    wire [7:0] data, address;

    meme_init meme_init_inst (
        .clk(clk), .state_start(reset_n),  

        //.finish(),
        //.init_mem_handler(),
        .data(data),
        .address(address),
        //.memory_sel(),
        .wen(wen)
    );
    
endmodule