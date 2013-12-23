`timescale 1ns / 1ps

module clk_div_tb();

reg clk_in;
reg rst;
reg ce;

wire [nDelay-1:0] clk_out;

parameter nDelay = 32;

genvar i;
generate
   for(i = 0; i < nDelay; i = i + 1) begin
      clk_div #(
         .DELAY(i)
      ) DUT (
         .clk_in(clk_in), 
         .rst(rst), 
         .ce(ce), 
         .clk_out(clk_out[i])
      );
   end
endgenerate

always #15.625 clk_in = ~clk_in;

// Initial input states
initial begin
   clk_in = 0;
   rst = 1;
   ce = 1;
end

// Test procedure below
initial begin
   #100 rst = 0;
   
end

endmodule