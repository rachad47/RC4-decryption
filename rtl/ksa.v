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

    // displays the secret_key
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1 (
        .ssOut(HEX0),
        .nIn(display[3:0])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2 (
        .ssOut(HEX1),
        .nIn(display[7:4])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3 (
        .ssOut(HEX2),
        .nIn(display[11:8])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4 (
        .ssOut(HEX3),
        .nIn(display[15:12])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5 (
        .ssOut(HEX4),
        .nIn(display[19:16])
    );
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst6 (
        .ssOut(HEX5),
        .nIn(display[21:20])
    );

    // core count    
    parameter CORE_COUNT_LOG_2 = 2;
    parameter CORE_COUNT = 2**CORE_COUNT_LOG_2;

    logic [21:0] counter, display, in_progress;
    logic [21:0] counters [CORE_COUNT-1:0];
    logic [CORE_COUNT-1:0] stop_all_signals;
    logic stop_all;

    // if any of cores finished, we stop everything else    
    assign stop_all = |stop_all_signals;

    always_comb begin
        counter = counters[0]; // Initialize result with the first element
        for (int i = 1; i < CORE_COUNT; i = i + 1) begin
            counter |= counters[i]; // Perform bitwise OR with the next element
        end
    end

    assign display = counter;

    assign LEDR = {10{stop_all}};  // indicating solved

    // assign counter = counters[SW];
    
    generate
        // generates the cores to decrypt the message
        genvar i;
        for (i = 0; i < CORE_COUNT; i = i + 1) begin: create_cores
            rc4_encapsulated decryptor_cores (
                .clk(clk),
                .reset(~KEY[3]),
                .start(SW[9]),
                .secret_key(counters[i]),
                .stop_all(stop_all),
                .correct_key_found(stop_all_signals[i]),
                .core_init_val(i),
                .total_cores(CORE_COUNT),
                .in_progress(in_progress[i])          // in case we want to show the in progress status
            );
        end
    endgenerate


endmodule