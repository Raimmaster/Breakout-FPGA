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
		
		if(ball_y <= 0) //screen boundaries check
		begin
			p_sound = 1;
			ball_dy = 0;
			//erase_e = 1;
		end
		
		if(ball_y > SCREEN_H - BALL_SIZE) //screen boundaries check
		begin
			play_sound2 = 1;
			ball_dy = ball_dy * -1;
			//erase_e = 1;
		end
		
		///*
		i = 0;
		if(active[i]) begin
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
		//c
			
		i = 1;
		if(active[1]) begin
			if ( (ball_y > 10'd40 && ball_y < 10'd70)  && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd158 && (ball_x - BALL_SIZE) < 10'd160 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd240 && (ball_x - BALL_SIZE) < 10'd242 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd1;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if((ball_x > 10'd160 && ball_x < 10'd240)  && 
				( 
					( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd1;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
			
		i = 2;
		if(active[i]) begin
			if ( (ball_y > 10'd40 && ball_y < 10'd70) && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd278 && (ball_x - BALL_SIZE) < 10'd280 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd360 && (ball_x - BALL_SIZE) < 10'd362 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd2;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if((ball_x > 10'd280 && ball_x < 10'd360) && 
				( 
					( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd2;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 3;
		if(active[i]) begin
			if ( (ball_y > 10'd40 && ball_y < 10'd70) && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd398 && (ball_x - BALL_SIZE) < 10'd400 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd480 && (ball_x - BALL_SIZE) < 10'd482 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd3;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if( (ball_x > 10'd400 && ball_x < 10'd480) && 
				( 
					( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd3;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 4;
		if(active[i]) begin
			if ( (ball_y > 10'd40 && ball_y < 10'd70) && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd518 && (ball_x - BALL_SIZE) < 10'd520 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd600 && (ball_x - BALL_SIZE) < 10'd602 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd4;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if( (ball_x > 10'd520 && ball_x < 10'd600)  && 
				( 
					( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 ) )
				)) begin
				erase_e = 1;
				erase_pos = 6'd4;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 5;
		if(active[i]) begin
			if ( (ball_y > 10'd90 && ball_y < 10'd120) && 
				( 
					( (ball_x + BALL_SIZE) > 10'd38 && (ball_x - BALL_SIZE) < 10'd40 ) 
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd120 && (ball_x - BALL_SIZE) < 10'd122 ) )
				)) begin
				erase_e = 1;
				erase_pos = 6'd5;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if( (ball_x > 10'd40 && ball_x < 10'd120) && 
				( 
					( (ball_y + BALL_SIZE) > 10'd88 && (ball_y - BALL_SIZE) < 10'd90 ) 
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd119 && (ball_y - BALL_SIZE) < 10'd121 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd5;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 6;
		if(active[i]) begin
			if ( (ball_y > 10'd90 && ball_y < 10'd120) && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd158 && (ball_x - BALL_SIZE) < 10'd160 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd240 && (ball_x - BALL_SIZE) < 10'd242 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd6;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if((ball_x > 10'd160 && ball_x < 10'd240) && 
				( 
					( ( (ball_y + BALL_SIZE) > 10'd88 && (ball_y - BALL_SIZE) < 10'd90 ) )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd119 && (ball_y - BALL_SIZE) < 10'd121 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd6;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 7;
		if(active[i]) begin
			if ( (ball_y > 10'd90 && ball_y < 10'd120) && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd278 && (ball_x - BALL_SIZE) < 10'd280 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd360 && (ball_x - BALL_SIZE) < 10'd362 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd7;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if((ball_x > 10'd280 && ball_x < 10'd360) && 
				( 
					( ( (ball_y + BALL_SIZE) > 10'd88 && (ball_y - BALL_SIZE) < 10'd90 ) )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd119 && (ball_y - BALL_SIZE) < 10'd121 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd7;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 8;
		if(active[i]) begin
			if ( (ball_y > 10'd90 && ball_y < 10'd120) && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd398 && (ball_x - BALL_SIZE) < 10'd400 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd480 && (ball_x - BALL_SIZE) < 10'd482 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd8;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if( (ball_x > 10'd400 && ball_x < 10'd480) && 
				( 
					( ( (ball_y + BALL_SIZE) > 10'd88 && (ball_y - BALL_SIZE) < 10'd90 ) )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd119 && (ball_y - BALL_SIZE) < 10'd121 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd8;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 9;
		if(active[i]) begin
			if ( (ball_y > 10'd90 && ball_y < 10'd120)  && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd518 && (ball_x - BALL_SIZE) < 10'd520 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd600 && (ball_x - BALL_SIZE) < 10'd602 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd9;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if( (ball_x > 10'd520 && ball_x < 10'd600)  && 
				( 
					( ( (ball_y + BALL_SIZE) > 10'd88 && (ball_y - BALL_SIZE) < 10'd90 ) )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd119 && (ball_y - BALL_SIZE) < 10'd121 ) )
				)) begin
				erase_e = 1;
				erase_pos = 6'd9;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 10;

		if(active[i]) begin
			if ( (ball_y > 10'd140 && ball_y < 10'd170)  && 
				( 
					( ( (ball_x + BALL_SIZE) > 10'd158 && (ball_x - BALL_SIZE) < 10'd160 ) )
				|| 
					( ( (ball_x + BALL_SIZE) > 10'd240 && (ball_x - BALL_SIZE) < 10'd242 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd10;
				ball_dx = ball_dx * -1;
				active[i] = 0;
			end
			if( (ball_x > 10'd160 && ball_x < 10'd240) && 
				( 
					( ( (ball_y + BALL_SIZE) > 10'd138 && (ball_y - BALL_SIZE) < 10'd140 ) )
				|| 
					( ( (ball_y + BALL_SIZE) > 10'd169 && (ball_y - BALL_SIZE) < 10'd171 ) )
				)
				) begin
				erase_e = 1;
				erase_pos = 6'd10;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end
		end
		
		i = 11;
		if(active[i]) begin
			if( (ball_y > 10'd140 && ball_y < 10'd170) 
				&& 
				( ( (ball_x + BALL_SIZE) > 10'd398 && (ball_x - BALL_SIZE) < 10'd400 ) 
					|| 
					( (ball_x + BALL_SIZE) > 10'd480 && (ball_x - BALL_SIZE) < 10'd482 ) )) begin
				erase_e = 1;
				erase_pos = 6'd11;
				ball_dy = ball_dy * -1;
				active[i] = 0;
			end

			if((ball_x > 10'd400 && ball_x < 10'd480) 
				&& 
				( ( (ball_y + BALL_SIZE) > 10'd138 && (ball_y - BALL_SIZE) < 10'd140 )
					|| 
					( (ball_y + BALL_SIZE) > 10'd169 && (ball_y - BALL_SIZE) < 10'd171 ) )) begin
				erase_e = 1;
				erase_pos = 6'd11;
				ball_dy = ball_dy * -1;
				active[i] = 0;
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
			ball_dx = -10'd4;
			ball_dy = -10'd4;
			
			for (i = 0; i < 12; i = i + 1) begin
				active[i] = 1;			
			end
		end
	end
endmodule

