/*This is the top level module for the Timer project
This project counts time in decimal and displays it
on the 7-segment displays.
It has a pause/continue switch and a reset button.

This project currently works as intended except that
it seems my 50Mhz clock is roughly only 30Mhz

TODO: Update Counter to output a clock pulse every time it reboots. 
Then the RateDivider will be unneccessary as a separate module.
*/
module Timer(CLOCK_50,KEY,SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50; 
	localparam CLOCK_SPEED = 26'd50_000_000;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	wire csClock; // Updates every centisecond
	wire dsClock; // Updates every decisecond
	wire sClock; //Updates every second 
	
	wire [3:0] csCount;
	wire [3:0] dsCount;
	wire [3:0] sCount;

	
	wire pauseSwitch;
	assign pauseSwitch = SW[0];
	
	wire nResetButton;
	assign nResetButton = KEY[0];
	
	
	
	RateDivider csRateDivider(.inputClock(CLOCK_50), .pause(pauseSwitch),
										.nReset(nResetButton), .outputClock(csClock));
										
	defparam csRateDivider.MAX_VAL = (CLOCK_SPEED / 26'd100) - 1;
	
	Counter csCounter(.clock(csClock), .nReset(nResetButton), .count(csCount));
							
	RateDivider dsRateDivider(.inputClock(CLOCK_50), .pause(pauseSwitch),
										.nReset(nResetButton), .outputClock(dsClock));
										
	defparam dsRateDivider.MAX_VAL = (CLOCK_SPEED / 26'd10) - 1;									
	
	Counter dsCounter(.clock(dsClock), .nReset(nResetButton), .count(dsCount));
							
	RateDivider sRateDivider(.inputClock(CLOCK_50), .pause(pauseSwitch),
										.nReset(nResetButton), .outputClock(sClock));
										
	defparam sRateDivider.MAX_VAL = CLOCK_SPEED - 1;
	
	Counter sCounter(.clock(sClock), .nReset(nResetButton),.count(sCount));
	
	HexDisplayTranslator csDisplay(.binInput(csCount), .hexDisplayOutput(HEX0));
	HexDisplayTranslator  dsDisplay(.binInput(dsCount), .hexDisplayOutput(HEX1));
	HexDisplayTranslator  sDisplay(.binInput(sCount), .hexDisplayOutput(HEX2));
	
	
	assign HEX3 = 7'b111_1111;
	assign HEX4 = 7'b111_1111;
	assign HEX5 = 7'b111_1111;
	

endmodule