`timescale 1ns / 1ps

module LnL_top_tb();

reg clk;
reg rst;
reg [3:0] btns;

wire [3:0] leds;

LnL_top DUT(
    .clk(clk),
    .rst(rst),
    .btns(btns),
    .leds(leds)
);

always #15.625 clk = ~clk;

initial begin // Start of 0
    clk = 0;
    rst = 1;
    btns = 0;
end

initial begin
    #100 rst = 0;
    
// Begin testing here
    btns = 4'b0000;
    
    #100 btns = 4'b0001;
    
    #1500 btns = 4'b0010;
    
    #1500 btns = 4'b0100;
    
    #1500 btns = 4'b1000;
    
    #3000 btns = 4'b0011;
    
end
endmodule