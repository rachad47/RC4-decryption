`timescale 1ns/1ps

module test_rc4_brute_force (
);

    logic clk;
    logic rst;
    logic valid;
    logic [21:0] init_val;
    logic [7:0] core_count;
    logic finish_decrypt; 
    logic stop_all;
    logic reset_pulse;
    logic solved;
    logic [21:0] counter;
    logic [21:0] solved_counter;

    rc4_brute_force DUT (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .init_val(0),
        .core_count(1),
        .finish_decrypt(finish_decrypt),
        .stop_all(stop_all),
        .reset_pulse(reset_pulse),
        .solved(solved),
        .counter(counter),
        .solved_counter(solved_counter)
    );

initial forever begin
    clk = 1'b0; #5;
    clk = 1'b1; #5;
end

initial begin
    rst = 1'b1; #10;
    rst = 1'b0; finish_decrypt = 1'b0; #10;
    #10;
    finish_decrypt = 1'b1; valid = 1'b0; #10;
    #10;
    #50;
    valid = 1'b1; #20;
    #20;
    rst = 1'b1; #10;
    rst = 1'b0; stop_all = 1'b1; #60;
    $stop;
end
    
endmodule