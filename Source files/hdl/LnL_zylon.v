`timescale 1ns / 1ps

module LnL_zylon(
    input clk,
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
                   STATE1 = 4'b0001, // ---0
                   STATE2 = 4'b0010, // --0-
                   STATE3 = 4'b0100, // -0--
                   STATE4 = 4'b1000; // 0---
    
    // Wires
    reg [LED_COUNT-1:0] next_state; // This will drive the next state. It's a wire because it will never be stored.
    
    // Registers
    reg reverse_state = 1'b0; // Is set in STATE4 for reversal
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
        if ( rst || !btn ) begin
            state <= RESET_STATE;
        end else begin
            // Rain meter holds values. EG: ---- -> ---0 -> --00 -> -000 -> 0000 -> ----
            state <= next_state;
        end
    end
    
    always @( posedge div_clk or posedge btn ) begin : ZYLON
        if ( rst || !btn ) begin
            leds <= 4'b0; // Reset state for the LEDs, they should all be off
        end else begin
            if ( btn == 1 ) // If the right_left_ctrl signal is 2'b01, it is moving to the left
                case(state)
                    RESET_STATE : begin leds <= 4'b0; next_state <= STATE1; end
                         STATE1 : begin leds <= 4'b0001; next_state <= STATE2; reverse_state = 1'b0; end
                         STATE2 : begin leds <= 4'b0010; next_state <= ( !reverse_state ) ? STATE3 : STATE1; end
                         STATE3 : begin leds <= 4'b0100; next_state <= ( !reverse_state ) ? STATE4 : STATE2; end
                         STATE4 : begin leds <= 4'b1000; next_state <= STATE3; reverse_state = 1'b1; end
                        default : begin leds <= 4'b0; next_state <= RESET_STATE; end // This must be here to not cause latches
                endcase
        end
    end
    
endmodule
