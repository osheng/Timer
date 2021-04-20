/*This is the top level module for the Timer project
This project counts time in decimal and displays it
on the 7-segment displays.
It has a pause/continue switch and a reset button.

Currently the RateDivider module is unnecessary

*/

module Timer(CLOCK_50,KEY,SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50;

	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	localparam SIZE = 26;
	
	wire msClock; // a clock with 1000 cps
	wire csClock; // a clock with 100 cps
	wire dsClock; // a clock with 10 cps
	wire sClock;  // a clock with 1 cps
	wire s10Clock;// a clock with 1/10 cps

	wire [SIZE - 1:0] garbage;
	wire [3:0] csCount;
	wire [3:0] dsCount;
	wire [3:0] sCount;
	wire [3:0] s10Count;


	wire pauseSwitch;
	assign pauseSwitch = SW[0];

	wire nResetButton;
	assign nResetButton = KEY[0];
	
	// I would have thought this should be 49_999
	defparam msCounter.MAX = 26'd499_999;
	defparam msCounter.SIZE = SIZE;
	Counter msCounter(.inputClock(CLOCK_50), .pause(pauseSwitch),
		.nReset(nResetButton), .count(garbage), .outputClock(msClock));
	
	Counter csCounter(.inputClock(msClock), .pause(pauseSwitch),
		.nReset(nResetButton), .count(csCount), .outputClock(csClock));

	Counter dsCounter(.inputClock(csClock), .pause(pauseSwitch),
		.nReset(nResetButton), .count(dsCount), .outputClock(dsClock));


	Counter sCounter(.inputClock(dsClock), .pause(pauseSwitch),
		.nReset(nResetButton), .count(sCount), .outputClock(sClock));

	defparam s10Counter.MAX = 6 - 1;
	Counter s10Counter(.inputClock(sClock), .pause(pauseSwitch),
		.nReset(nResetButton), .count(s10Count), .outputClock(s10Clock));

	HexDisplayTranslator csDisplay(.binInput(csCount), .hexDisplayOutput(HEX0));
	HexDisplayTranslator  dsDisplay(.binInput(dsCount), .hexDisplayOutput(HEX1));
	HexDisplayTranslator  sDisplay(.binInput(sCount), .hexDisplayOutput(HEX2));
	HexDisplayTranslator  s10Display(.binInput(s10Count), .hexDisplayOutput(HEX3));
	assign HEX4 = 7'b111_1111;
	assign HEX5 = 7'b111_1111;


endmodule
