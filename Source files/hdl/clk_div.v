`timescale 1ns / 1ps

module clk_div(
    input clk_in,
    input rst,
    input ce,
    output clk_out
    );

// Parameters
parameter DELAY=0; // 0 - default

// Wires

// Registers
reg [DELAY:0] clk_buffer;

assign clk_out = clk_buffer[DELAY];

always @(posedge clk_in) begin
    if ( rst ) begin
        clk_buffer <= 0;
    end else begin
        if ( ce == 1) 
            clk_buffer <= clk_buffer + 1;
    end
end

endmodule
