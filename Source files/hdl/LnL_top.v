`timescale 1ns / 1ps

module LnL_top(
    input clk,
    input rst,
    input [BUTTON_COUNT-1:0] btns,
    output reg [LED_COUNT-1:0] leds
    );

parameter BUTTON_COUNT = 4;
parameter LED_COUNT = 4;
parameter DELAY = 24;

wire [LED_COUNT-1:0] rainmeter_leds, zylon_leds, counter_leds, lsfr_leds;

LnL_rainmeter #(
    .LED_COUNT(LED_COUNT),
    .DELAY(DELAY)
) SFE_rainmeter (
    .clk(clk),
    .rst(rst),
    .btn(btns[0]),
    .leds(rainmeter_leds)
);

LnL_zylon #(
    .LED_COUNT(LED_COUNT),
    .DELAY(DELAY)
) SFE_zylon (
    .clk(clk),
    .rst(rst),
    .btn(btns[1]),
    .leds(zylon_leds)
);

LnL_counter #(
    .LED_COUNT(LED_COUNT),
    .DELAY(DELAY)
) SFE_counter (
    .clk(clk),
    .rst(rst),
    .btn(btns[2]),
    .leds(counter_leds)
);

LnL_LSFR #(
    .LED_COUNT(LED_COUNT),
    .DELAY(DELAY)
) SFE_LSFR (
    .clk(clk),
    .rst(rst),
    .btn(btns[3]),
    .leds(lsfr_leds)
);

always @(posedge clk)
   case (btns)
      4'b0000: leds <= 4'hF;
      4'b0001: leds <= rainmeter_leds;
      4'b0010: leds <= zylon_leds;
      4'b0100: leds <= counter_leds;
      4'b1000: leds <= lsfr_leds;
      default : leds <= (leds != 4'b0101) ? 4'b0101 : 4'b1010;
   endcase

endmodule
