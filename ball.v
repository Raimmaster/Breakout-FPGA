`timescale 1ns / 1ps

module ball(
    input [9:0] paddle_x,
    //input [9:0] paddle_y,
    input reset,
    input clk,
    output [9:0] x_out,
    output [9:0] y_out,
	 output erase_enable,
	 output [5:0] e_pos,
	 output play_sound1,
	 output reg play_sound2
    );
	parameter
		SCREEN_W = 640,
		SCREEN_H = 480,
		BALL_SIZE = 7,
		BLOCK_SPACING_X = 10'd40,
		BLOCK_SPACING_Y = 10'd20,
		BLOCK_WIDTH = 10'd80,
		BLOCK_HEIGHT = 10'd30;

	reg [9:0] ball_x;	
	reg [9:0] ball_y;
	
	reg signed [9:0] ball_dx;
	reg signed [9:0] ball_dy;
	
	assign x_out = ball_x;
	assign y_out = ball_y;
	
	reg erase_e;
	reg [5:0] erase_pos;
	
	reg win;
	
	reg p_sound;
	assign play_sound1 = p_sound;
	
	reg active [11:0];
	integer i;
	
	assign e_pos = erase_pos;
	assign erase_enable = erase_e;

	always @ (posedge clk) begin
		erase_e = 0;
		
		
		if((ball_x) <= 0 || ball_x >= SCREEN_W - BALL_SIZE) //screen boundaries check
		begin
			ball_dx = ball_dx * -1;
		end
		
		if(ball_y <= 1) //screen boundaries check
		begin
			p_sound = 1;
			ball_dy = ball_dy * -1;
			//erase_e = 1;
		end
		
		if(ball_y > SCREEN_H - BALL_SIZE) //screen boundaries check
		begin
			play_sound2 = 1;
			ball_dy = 0;
			//erase_e = 1;
		end
		
		///*
		for (i = 0; i < n; i = i + 1)
		begin						
			if(active[i]) begin
				if(i < 5) begin
					if (ball_x > BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i)) begin
						if (ball_y > ) begin
							
						end
					end
				end
				else if (i < 10) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-5));
					data_y[i] = SECOND_ROW_Y;
					active[i] = 1;
				end
				if(
					(ball_y > 10'd40 && ball_y < 10'd70)  && 
					(( (ball_x + BALL_SIZE) > 10'd38 && (ball_x - BALL_SIZE) < 10'd40 ) 
						||
						( (ball_x + BALL_SIZE) > 10'd120 && (ball_x - BALL_SIZE) < 10'd122 )
						)
				) begin
					erase_e = 1;
					erase_pos = 6'd0;
					ball_dx = ball_dx * -1;
					active[i] = 0;
				end
				
				if ( (ball_x > 10'd40 && ball_x < 10'd120) && 
				(( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 ) || 
					( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 )
				))
				begin
					erase_e = 1;
					erase_pos = 6'd0;
					ball_dy = ball_dy * -1;
					active[i] = 0;
				end
			end		
		end
		
		win = 1;
		for (i = 0; i < 12; i = i + 1) begin
				if (active[i])
					win = 0;
		end
			
		p_sound = erase_e;
		play_sound2 = 0;
		if( (ball_x > paddle_x && ball_x < (paddle_x + 100)) && ( ( (ball_y + BALL_SIZE) >= 10'd439 && (ball_y - BALL_SIZE) < 10'd440) ) ) //paddle collision
		begin
			ball_dy = ball_dy * -1;
			play_sound2 = 1;
		end
				
		if (win) begin
			ball_dx = 10'd0;
			ball_dy = 10'd0;
		end

		ball_x = ball_x + ball_dx;
		ball_y = ball_y + ball_dy;

		if(reset)begin
			ball_x = 10'd270; //'
			ball_y = 10'd450; //'
			ball_dx = -10'd1;
			ball_dy = -10'd1;
			
			for (i = 0; i < 12; i = i + 1) begin
				active[i] = 1;			
			end
		end
	end
endmodule

