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
    LnL_rainmeter #(
        .LED_COUNT(4)
    ) your_instance_name (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .leds(leds)
    );
*/

module LnL_rainmeter(
    input clk, // Should be fed a 1Hz clock
    input rst,
    input btn,
    output reg [LED_COUNT-1:0] leds
    );

// Module Parameters
parameter LED_COUNT = 4; 
parameter DELAY = 0;

// State Machine Parameters
// Parameterization to determine what state the machine is in. Synthesis will choose 1-hot for us by default
parameter RESET_STATE = 4'b0000, // ---- 
               STATE1 = 4'b0001, // ---0 or 0---
               STATE2 = 4'b0010, // --00 or 00--
               STATE3 = 4'b0100, // -000 or 000-
               STATE4 = 4'b1000; // 0000 or 0000

// Wires
reg reverse_state;

initial reverse_state = 1'b0;

// Registers
reg [LED_COUNT-1:0] next_state; // This will drive the next state. It's a wire because it will never be stored.
reg [LED_COUNT-1:0] state; // State Machine controller register

// Clock reducer
clk_div #(
    .DELAY(DELAY)
) clk_div_1 (
    .clk_in(clk),
    .clk_out(div_clk),
    .rst(rst),
    .ce(1'b1)
);

// State Machine
always @( posedge div_clk ) begin : STATE_MACHINE_CONTROLLER // This defines hierarchy naming, helps with debugging
    if ( rst ) begin
        state <= RESET_STATE;
    end else begin
        // Rain meter holds values. EG: ---- -> ---0 -> --00 -> -000 -> 0000 -> ----
        state <= next_state;
    end
end

always @( posedge div_clk or posedge state[3] ) begin : REVERSE_STATE
    if ( rst )
        reverse_state <= 1'b0;
    else
        if ( state[3] == 1'b1 )
            reverse_state <= ~reverse_state;
        else
            reverse_state <= reverse_state;
end

always @( posedge div_clk ) begin : RAINMETER
    if ( rst ) begin
        leds <= 4'b0; // Reset state for the LEDs, they should all be off
    end else begin
        case(state)
            RESET_STATE : begin leds <= 4'b0; next_state <= STATE1; end
                 STATE1 : begin leds <= (!reverse_state) ? 4'b1000 : 4'b0001; next_state <= STATE2; end
                 STATE2 : begin leds <= (!reverse_state) ? 4'b1100 : 4'b0011; next_state <= STATE3; end
                 STATE3 : begin leds <= (!reverse_state) ? 4'b1110 : 4'b0111; next_state <= STATE4; end
                 STATE4 : begin leds <= 4'b1111; next_state <= RESET_STATE; end
                default : begin leds <= 4'b0; next_state <= RESET_STATE; end // This must be here to not cause latches
        endcase
    end
end

/*always @( posedge div_clk ) begin : RAINMETER_LEFT
    if ( rst ) begin
        leds <= 4'b0; // Reset state for the LEDs, they should all be off
    end else begin
        if ( reverse_state ) begin
            case(state)
            RESET_STATE : begin leds <= 4'b0; next_state <= STATE1; end
                 STATE1 : begin leds <= (!reverse_state) ? 4'b1000 : 4'b0001; next_state <= STATE2; end
                 STATE2 : begin leds <= (!reverse_state) ? 4'b1100; 4'b0011; next_state <= STATE3; end
                 STATE3 : begin leds <= (!reverse_state) ? 4'b1110; 4'b0111; next_state <= STATE4; end
                 STATE4 : begin leds <= 4'b1111; next_state <= RESET_STATE; end
                default : begin leds <= 4'b0; next_state <= RESET_STATE; end // This must be here to not cause latches
            endcase
        end
    end
end*/
    
endmodule
