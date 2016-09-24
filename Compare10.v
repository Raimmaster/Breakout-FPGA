`timescale 1ns / 1ps

module Compare10(
    input [9:0] a,
    input [9:0] b,
    output equal,
    output greater,
    output less
    );

	assign equal = a == b;
	assign greater = a > b;
	assign less = a < b;
	
endmodule
