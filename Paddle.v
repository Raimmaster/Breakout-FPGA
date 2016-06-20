`timescale 1ns / 1ps

module Paddle(
    input btn_left,
    input btn_right,
    input reset,
    input clk,
    output [9:0] pos
    );

	reg [9:0] position;
	
	assign pos = position;

	always @ (posedge clk) begin
		if(reset)begin
			position = 10'd270; //'
		end
		if(btn_left && position > 10)begin
			position = position - 10;
		end
		else if (btn_right && position < 640 - 100 - 10)begin
			position = position + 10;
		end
	end
endmodule
