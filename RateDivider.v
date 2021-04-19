module RateDivider(inputClock, pause, nReset, outputClock);
	input inputClock, pause, nReset;
	output reg outputClock;
	parameter MAX_VAL = 26'd50_000_000;
	reg [25:0] counter;
	
	always @(posedge inputClock, posedge pause, negedge nReset)
	begin
	if (!nReset) begin
		outputClock <= 1'b0;
		counter <= 26'b0;
	end
	else if (pause) counter <= counter;
	else if (counter >= MAX_VAL) begin
		counter <= 26'b0;
		outputClock <= ~outputClock;
	end
	else counter <= counter + 26'b1;
	end
endmodule
	