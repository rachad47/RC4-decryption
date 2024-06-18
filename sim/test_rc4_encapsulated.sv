`timescale 1ns/1ps

module test_rc4_encapsulated ();

    logic clk;
    logic reset;
    logic start;
    logic stop_all;
    logic [7:0] core_init_val;
    logic [7:0] total_cores;
    logic [21:0] secret_key, in_progress;
    logic correct_key_found;

rc4_encapsulated DUT (
    .clk(clk),
    .reset(reset),
    .start(start),
    .stop_all(stop_all),
    .core_init_val(core_init_val),
    .total_cores(total_cores),
    .secret_key(secret_key),
    .in_progress(in_progress)
    .correct_key_found(correct_key_found)
);

initial forever begin
    clk = 1'b0; #5;
    clk = 1'b1; #5;
end

initial begin
    reset = 1'b1; #10;
    reset = 1'b0; #10;
    start = 1'b1; #10;
    start = 1'b0; #10;

    #400;
end

endmodule,
