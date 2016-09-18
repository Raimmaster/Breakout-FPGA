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
		FIRST_ROW_Y = 10'd40,
		SECOND_ROW_Y = 10'd90,		
		THIRD_ROW_Y = 10'd140,
		FOURTH_ROW_Y = 10'd190,
		FIFTH_ROW_Y = 10'd240,
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
	reg [9:0] temp1;
	reg [9:0] temp2;
	reg [5:0] i;
	reg [5:0] j;

	reg c_a1;
	reg c_b1;
	
	wire w_a1;
	wire w_b1;
	wire w_e1;
	wire w_g1;
	wire w_l1;
	assign w_a1 = c_a1;
	assign w_b1 = c_b1;
	Compare10 cmp1(w_a1, w_b1, w_e1, w_g1, w_l1);

	reg c_a2;
	reg c_b2;
	
	wire w_a2;
	wire w_b2;
	wire w_e2;
	wire w_g2;
	wire w_l2;
	assign w_a2 = c_a2;
	assign w_b2 = c_b2;
	Compare10 cmp1(w_a2, w_b2, w_e2, w_g2, w_l2);

	reg c_a3;
	reg c_b3;
	
	wire w_a3;
	wire w_b3;
	wire w_e3;
	wire w_g3;
	wire w_l3;
	assign w_a3 = c_a3;
	assign w_b3 = c_b3;
	Compare10 cmp3(w_a3, w_b3, w_e3, w_g3, w_l3);

	reg c_a4;
	reg c_b4;
	
	wire w_a4;
	wire w_b4;
	wire w_e4;
	wire w_g4;
	wire w_l4;
	assign w_a4 = c_a4;
	assign w_b4 = c_b4;
	Compare10 cmp4(w_a4, w_b4, w_e4, w_g4, w_l4);

	reg c_a5;
	reg c_b5;
	
	wire w_a5;
	wire w_b5;
	wire w_e5;
	wire w_g5;
	wire w_l5;
	assign w_a5 = c_a5;
	assign w_b5 = c_b5;
	Compare10 cmp5(w_a5, w_b5, w_e5, w_g5, w_l5);

	reg c_a6;
	reg c_b6;
	
	wire w_a6;
	wire w_b6;
	wire w_e6;
	wire w_g6;
	wire w_l6;
	assign w_a6 = c_a6;
	assign w_b6 = c_b6;
	Compare10 cmp6(w_a6, w_b6, w_e6, w_g6, w_l6);
	
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
		for (i = 0; i < 10; i = i + 1)
		begin
					
			if (i<5) begin
				temp1 = FIRST_ROW_Y;	
				temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *i;			
			end
			else begin
				temp1 = SECOND_ROW_Y;
				temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(i-5);
			end

			if(active[i]) begin
				if(
					(ball_y > temp1  && ball_y < (temp1 + BLOCK_HEIGHT) )  && 
					(( (ball_x + BALL_SIZE) > (temp2 - 2) && (ball_x - BALL_SIZE) < temp2 ) 
						||	
						( (ball_x + BALL_SIZE) > (temp2 + BLOCK_WIDTH) && (ball_x - BALL_SIZE) < (temp2 + BLOCK_WIDTH + 2) )
						)
				) begin
					erase_e = 1;
					erase_pos = i;
					ball_dx = ball_dx * -1;
					active[i] = 0;
				end
				
				if ( (ball_x > temp2 && ball_x < (temp2 + BLOCK_WIDTH)) && 
				(( (ball_y + BALL_SIZE) > (temp1 -2) && (ball_y - BALL_SIZE) < temp1 ) || 
					( (ball_y + BALL_SIZE) > (temp1 + BLOCK_HEIGHT -1) && (ball_y - BALL_SIZE) < (temp1 + BLOCK_HEIGHT +1) )
				))
				begin
					erase_e = 1;
					erase_pos = i;
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

