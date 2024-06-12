module meme_init (
    input logic clk, 
    input logic state_start,
    //
    output logic finish, meme_init_start,
    output logic [7:0] data, 
    output logic [7:0] address,
    output logic [1:0] sel,
    output logic wen
);

logic [8:0] i; // i as internal signal

always_ff @(posedge clk) begin
    if (state_start) begin
        i <= 8'h00;
        meme_init_start <= 1;

    end else begin
        if (i == 9'h100) begin  // 9'h100 = 256 , the idea here is to stop at 256 in way we can read 255
            finish <= 1;
            wen <= 0;
            meme_init_start <= 0;
            
        end else begin
            finish <= 0;
            i <= i + 1;
            wen <= 1;

        end
    end
end

assign data = i;
assign address = i;
assign sel = 2'b01;

endmodule
