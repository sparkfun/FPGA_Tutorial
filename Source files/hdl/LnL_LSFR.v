`timescale 1ns / 1ps

// Name: LnL_rainmeter
// Description: This module utilizes buttons/LEDs to display a rainmeter output. Pressing a button once will activate it, pressing it again,
// will reverse it, and pressing it again will return it to normal. Holding the button down for 3 seconds will turn it off.
// Inputs:
// - INPUT clk - The system clock that will synchronize everything
// - INPUT rst - The system reset. This will reset everything in a synchronous manner
// - INPUT btn - Button to control how the rainmeter will work
// - OUTPUT leds - The output of the LEDs

/* Instantiation Template
    LnL_counter #(
        .LED_COUNT(4)
    ) your_instance_name (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .leds(leds)
    );
*/

module LnL_LSFR(
    input clk, // Should be fed a 1Hz clock
    input rst,
    input btn,
    output reg [LED_COUNT-1:0] leds
    );

// Module Parameters
parameter LED_COUNT = 4; 
parameter DELAY = 0;

wire div_clk;

wire feedback;

clk_div #(
    .DELAY(DELAY)
) clk_div_1 (
    .clk_in(clk),
    .clk_out(div_clk),
    .rst(rst),
    .ce(1'b1)
);

assign feedback = (leds[0] ^ leds[3]);

always @(posedge div_clk ) begin: LSFR
    if ( rst ) 
        leds <= 4'hF;
    else
        if ( btn ) 
            leds <= {leds[2:0], feedback};   
end

endmodule