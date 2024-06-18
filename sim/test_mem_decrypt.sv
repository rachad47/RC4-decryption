`timescale 1ns/1ps
module test_mem_decrypt ();

    logic  clk;
    logic start;
    logic reset;
    logic [7:0] q_data;

    logic finish, decrypt_mem_handler;
    logic [7:0] data;
    logic [7:0] address;
    logic [1:0] memory_sel;
    logic wen;
    logic valid_test;
    logic other_finished;

    mem_decrypt DUT (
        .clk(clk),
        .start_sig(start),
        .reset(reset),
        .q_data(q_data),
        .finish(finish),
        .decrypt_mem_handler(decrypt_mem_handler),
        .data(data),
        .address(address),
        .memory_sel(memory_sel),
        .wen(wen),
        .iterations(1),
        .valid_test(valid_test),
        .other_finished(other_finished)
    );

    initial forever begin
       clk = 1'b0; #5;
       clk = 1'b1; #5; 
    end

    initial begin
        valid_test = 1'b1;
        other_finished = 1'b0;
        q_data = 1;
        reset = 1'b1; #10;
        reset = 1'b0; #10;
        #10;
        start = 1'b1; #10;
        start = 1'b0; 

        #500;

        reset = 1'b1; #10;
        reset = 1'b0; start = 1'b1; #10;

        other_finished = 1'b1; 

        #300;

        $stop;
    end

endmodule