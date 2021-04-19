module Counter(clock, nReset, count);
	input clock, nReset;
	parameter MAX_VAL = 4'd9; // must be <= 4'd15
	output reg [3: 0]count;
	
	always @(posedge clock, negedge nReset)
	begin
		if (!nReset) count <= 0;
		else if (count >= MAX_VAL) count <= 0;
		else count <= count + 4'd1;	
	end

endmodule