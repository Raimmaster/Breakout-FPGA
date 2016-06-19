`timescale 1ns / 1ps

module ball(
    //input [9:0] x,
    //input [9:0] y,
    input reset,
    input clk,
    output [9:0] x_out,
    output [9:0] y_out
    );
	parameter
		SCREEN_W = 640,
		SCREEN_H = 480,
		BALL_SIZE = 4;

	reg [9:0] ball_x;	
	reg [9:0] ball_y;
	
	reg signed [9:0] ball_dx;	
	reg signed [9:0] ball_dy;
	
	assign x_out = ball_x;
	assign y_out = ball_y;

	always @ (posedge clk) begin
		ball_dx = -10'd4;
		ball_dy = 10'd4;
	
		if(ball_x < 0 || ball_x > SCREEN_W - BALL_SIZE)begin
			ball_dx = -ball_dx;
		end

		if(ball_y < 0 || ball_y > SCREEN_H - BALL_SIZE)begin
			ball_dy = -ball_dy;
		end

		ball_x = ball_x + ball_dx;
		ball_y = ball_y + ball_dy;

		if(reset)begin
			ball_x = 10'd270; //'
			ball_y = 10'd410; //'
		end
	end
endmodule

