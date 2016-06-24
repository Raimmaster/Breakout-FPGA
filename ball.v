`timescale 1ns / 1ps

module ball(
    input [9:0] paddle_x,
    //input [9:0] paddle_y,
    input reset,
    input clk,
    output [9:0] x_out,
    output [9:0] y_out,
	 output erase_enable,
	 output [5:0] e_pos
    );
	parameter
		SCREEN_W = 640,
		SCREEN_H = 480,
		BALL_SIZE = 7,
		BLOCK_SPACING_X = 10'd40,
		BLOCK_WIDTH = 10'd80,
		BLOCK_HEIGHT = 10'd30,
		FIRST_ROW_Y = 10'd40,
		SECOND_ROW_Y = 10'd90,		
		THIRD_ROW_Y = 10'd140,
		FOURTH_ROW_Y = 10'd190,
		FIFTH_ROW_Y = 10'd240;

	reg [9:0] ball_x;	
	reg [9:0] ball_y;
	
	reg signed [9:0] ball_dx;
	reg signed [9:0] ball_dy;
	
	assign x_out = ball_x;
	assign y_out = ball_y;
	
	reg erase_e;
	reg [5:0] erase_pos;
	
	reg active [24:0];
	integer i;
	
	assign e_pos = erase_pos;
	assign erase_enable = erase_e;

	always @ (posedge clk) begin
		erase_e = 0;
		
		
		
		if((ball_x) <= 0 || ball_x >= SCREEN_W - BALL_SIZE) //screen boundaries check
		begin
			ball_dx = ball_dx * -1;
		end
		
		
		
		if(active[0]) begin
		
			if(
				( (ball_y > 10'd40 && ball_y < 10'd70) && 
				(( (ball_x + BALL_SIZE) > 10'd38 && (ball_x - BALL_SIZE) < 10'd40 ) 
					||
					( (ball_x + BALL_SIZE) > 10'd120 && (ball_x - BALL_SIZE) < 10'd122 )
					)
			)) begin
				erase_e = 1;
				erase_pos = 6'd0;
				ball_dx = ball_dx * -1;
				active[0] = 0;
			end
			
			if ( (ball_x > 10'd40 && ball_x < 10'd120) && 
			(( (ball_y + BALL_SIZE) > 10'd38 && (ball_y - BALL_SIZE) < 10'd40 ) || 
				( (ball_y + BALL_SIZE) > 10'd69 && (ball_y - BALL_SIZE) < 10'd71 )
			))
			begin
				erase_e = 1;
				erase_pos = 6'd0;
				ball_dy = ball_dy * -1;
				active[0] = 0;
			end
		end
		
		if(active[1]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[2]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[3]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[4]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[5]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[6]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[7]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[8]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[9]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[10]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[11]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[12]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[13]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[14]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[15]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[16]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[17]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[18]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[19]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[20]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[21]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[22]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[23]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		
		if(active[24]) begin
			if ( && ( || )) begin
			
			end
			if(&& ( || )) begin
			
			end
		end
		

		if(ball_y <= 0 || ball_y > SCREEN_H - BALL_SIZE) //screen boundaries check
		begin
			ball_dy = ball_dy * -1;
			//erase_e = 1;
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
			
			for (i = 0; i < 25; i = i + 1) begin
				active[i] = 1;			
			end
		end
	end
endmodule

