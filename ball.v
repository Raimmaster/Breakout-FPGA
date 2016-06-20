`timescale 1ns / 1ps

module ball(
    input [9:0] paddle_x,
    //input [9:0] paddle_y,
    input reset,
    input clk,
    output [9:0] x_out,
    output [9:0] y_out
    );
	parameter
		SCREEN_W = 640,
		SCREEN_H = 480,
		BALL_SIZE = 7;

	reg [9:0] ball_x;	
	reg [9:0] ball_y;
	
	reg signed [9:0] ball_dx;
	reg signed [9:0] ball_dy;
	
	assign x_out = ball_x;
	assign y_out = ball_y;

	always @ (posedge clk) begin

		if((ball_x) <= 0 || ball_x >= SCREEN_W - BALL_SIZE //screen boundaries check
			|| ( ( (ball_y > 10'd40 && ball_y < 10'd70) //comparing columns; first column 
				|| (ball_y > 10'd90 && ball_y < 10'd120) // second column
				|| (ball_y > 10'd140 && ball_y < 10'd170) //third column
				|| (ball_y > 10'd190 && ball_y < 10'd220) //fourth column
				|| (ball_y > 10'd240 && ball_y < 10'd270) ) //fifth column
				&& (//left column
					( ( (ball_x + BALL_SIZE) > 10'd38 && (ball_x - BALL_SIZE) < 10'd40 ) )//first row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd158 && (ball_x - BALL_SIZE) < 10'd160 ) )//second row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd278 && (ball_x - BALL_SIZE) < 10'd280 ) )//third row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd398 && (ball_x - BALL_SIZE) < 10'd400 ) )//fourth row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd518 && (ball_x - BALL_SIZE) < 10'd520 ) )//fifth row collision 
					|| //right column
					   ( ( (ball_x + BALL_SIZE) > 10'd120 && (ball_x - BALL_SIZE) < 10'd122 ) )//first row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd240 && (ball_x - BALL_SIZE) < 10'd242 ) )//second row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd360 && (ball_x - BALL_SIZE) < 10'd362 ) )//third row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd480 && (ball_x - BALL_SIZE) < 10'd482 ) )//fourth row collision 
					|| ( ( (ball_x + BALL_SIZE) > 10'd600 && (ball_x - BALL_SIZE) < 10'd602 ) )//fifth row collision 
					) 
				)
			)
		begin
			ball_dx = ball_dx * -1;
		end

		if(ball_y <= 0 || ball_y > SCREEN_H - BALL_SIZE //screen boundaries check
			|| ( ( (ball_x > 10'd40 && ball_x < 10'd120) //comparing columns; first column 
				|| (ball_x > 10'd160 && ball_x < 10'd240) // second column
				|| (ball_x > 10'd280 && ball_x < 10'd360) //third column
				|| (ball_x > 10'd400 && ball_x < 10'd480) //fourth column
				|| (ball_x > 10'd520 && ball_x < 10'd600) ) //fifth column
				&& (//upper rows
					( ( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 ) )//first row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd88 && (ball_y - BALL_SIZE) < 10'd90 ) )//second row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd138 && (ball_y - BALL_SIZE) < 10'd140 ) )//third row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd188 && (ball_y - BALL_SIZE) < 10'd190 ) )//fourth row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd238 && (ball_y - BALL_SIZE) < 10'd240 ) )//fifth row collision 
					|| //lower rows
					   ( ( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 ) )//first row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd119 && (ball_y - BALL_SIZE) < 10'd121 ) )//second row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd169 && (ball_y - BALL_SIZE) < 10'd171 ) )//third row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd219 && (ball_y - BALL_SIZE) < 10'd221 ) )//fourth row collision 
					|| ( ( (ball_y + BALL_SIZE) > 10'd269 && (ball_y - BALL_SIZE) < 10'd271 ) )//fifth row collision 
					) 
				) 
			)
		begin
			ball_dy = ball_dy * -1;
		end

		if( (ball_x > paddle_x && ball_x < (paddle_x + 100)) && ( ( (ball_y + BALL_SIZE) >= 10'd439 && (ball_y - BALL_SIZE) < 10'd450) ) ) //paddle collision
		begin
			ball_dy = ball_dy * -1;
		



		end

		ball_x = ball_x + ball_dx;
		ball_y = ball_y + ball_dy;

		if(reset)begin
			ball_x = 10'd270; //'
			ball_y = 10'd450; //'
			ball_dx = -10'd4;
			ball_dy = -10'd4;
		end
	end
endmodule

