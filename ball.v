`timescale 1ns / 1ps

module ball(
	input [9:0] paddle_x,
   	//input [9:0] paddle_y,
   	input reset,
   	input start,
   	input clk,
	input clk_50mh,
  	output [9:0] x_out,
   	output [9:0] y_out,
	output erase_enable,
	output [5:0] e_pos,
	output reg [2:0] play_sound1,
	//output reg play_sound2,
	output reg [1:0] active_data
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
	reg [5:0] address;
	reg win;
	
	//reg p_sound	//assign play_sound1 = p_sound;
	
	reg [1:0] active [24:0];
	reg [9:0] temp1;
	reg [9:0] temp2;
	reg [5:0] i;
	reg start_movement;
	//reg [5:0] j;

	assign e_pos = erase_pos;
	assign erase_enable = erase_e;
	
	always @ (posedge clk_50mh) begin
	
	end

	always @ (posedge clk) begin
		erase_e = 0;
		
		if(start)
			start_movement = 1;

		if(!start_movement)begin
			ball_x = paddle_x + BALL_SIZE + 10'd40;
		end

		if(start_movement)begin
			if((ball_x) <= 0 || ball_x >= SCREEN_W - BALL_SIZE) //screen boundaries check
			begin
				ball_dx = ball_dx * -1;
			end
			
			if(ball_y <= 1) //screen boundaries check
			begin
				play_sound1 = 3'b001;
				ball_dy = ball_dy * -1;
				//erase_e = 1;
			end
			
			if(ball_y > SCREEN_H - BALL_SIZE) //screen boundaries check
			begin
				play_sound1 = 3'b100;
				ball_dy = 0;
				//erase_e = 1;
			end	
			
			address = address + 10'd1;
			if(address >= 10'd10)
				address = 10'd0;
			/*if (ball_y >= FIFTH_ROW_Y)
				address = 10'd19;
			else if (ball_y >= FOURTH_ROW_Y && (address > 19))
				address = 10'd14;
			else if (ball_y >= THIRD_ROW_Y && (address > 14))
				address = 10'd9;
			else if (ball_y >= SECOND_ROW_Y && (address > 9))
				address = 10'd5;
			else if (ball_y >= 0 &&( (address > 4)))
				address = 10'd0;*/
			
						
				if (address<5) begin
					temp1 = FIRST_ROW_Y;	
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *address;			
				end
				else if (address < 10) begin
					temp1 = SECOND_ROW_Y;
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(address-5);
				end
				/*else if (address < 15) begin
					temp1 = THIRD_ROW_Y;
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(address-10);
				end
				else if (address < 20) begin
					temp1 = FOURTH_ROW_Y;
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(address-15);
				end
				else if (address < 25) begin
					temp1 = FIFTH_ROW_Y;
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(address-20);
				end*/

				if(active[address] < 3) begin
					if(
						(ball_y >= temp1  && ball_y <= (temp1 + BLOCK_HEIGHT) )  && 
						(( (ball_x + BALL_SIZE) >= (temp2) && (ball_x - BALL_SIZE) <= temp2 ) 
							||	
							( (ball_x + BALL_SIZE) >= (temp2 + BLOCK_WIDTH) && (ball_x - BALL_SIZE) <= (temp2 + BLOCK_WIDTH) )
							)
					) begin
						erase_e = 1;
						erase_pos = address;
						ball_dx = ball_dx * -1;
						active[address] = active[address] + 1;
						play_sound1 = active[address];
						active_data = active[address];
					end
					
					else if ( (ball_x >= temp2 && ball_x <= (temp2 + BLOCK_WIDTH)) && 
					(( (ball_y + BALL_SIZE) >= (temp1) && (ball_y - BALL_SIZE) <= temp1 ) || 
						( (ball_y + BALL_SIZE) >= (temp1 + BLOCK_HEIGHT) && (ball_y - BALL_SIZE) <= (temp1 + BLOCK_HEIGHT) )
					))
					begin
						erase_e = 1;
						erase_pos = address;
						ball_dy = ball_dy * -1;
						active[address] = active[address] + 1;
						play_sound1 = active[address];
						active_data = active[address];
					end
				end
				
				if (address<5) begin
					temp1 = THIRD_ROW_Y;	
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(address);			
				end
				else if (address < 10) begin
					temp1 = FOURTH_ROW_Y;
					temp2 = BLOCK_SPACING_X + (BLOCK_WIDTH + BLOCK_SPACING_X) *(address-5);
				end
				if(active[address + 10'd10] < 3) begin
					if(
						(ball_y >= temp1  && ball_y <= (temp1 + BLOCK_HEIGHT) )  && 
						(( (ball_x + BALL_SIZE) >= (temp2) && (ball_x - BALL_SIZE) <= temp2 ) 
							||	
							( (ball_x + BALL_SIZE) >= (temp2 + BLOCK_WIDTH) && (ball_x - BALL_SIZE) <= (temp2 + BLOCK_WIDTH) )
							)
					) begin
						erase_e = 1;
						erase_pos = address + 10'd10;
						ball_dx = ball_dx * -1;
						active[address + 10'd10] = active[address + 10'd10] + 1;
						play_sound1 = active[address + 10'd10];
						active_data = active[address + 10'd10];
					end
					
					else if ( (ball_x >= temp2 && ball_x <= (temp2 + BLOCK_WIDTH)) && 
					(( (ball_y + BALL_SIZE) >= (temp1) && (ball_y - BALL_SIZE) <= temp1 ) || 
						( (ball_y + BALL_SIZE) >= (temp1 + BLOCK_HEIGHT) && (ball_y - BALL_SIZE) <= (temp1 + BLOCK_HEIGHT) )
					))
					begin
						erase_e = 1;
						erase_pos = address + 10'd10;
						ball_dy = ball_dy * -1;
						active[address + 10'd10] = active[address + 10'd10] + 1;
						play_sound1 = active[address + 10'd10];
						active_data = active[address + 10'd10];
					end
				end
			
			win = 1;
			for (i = 0; i < 20; i = i + 1) begin
					if (active[i] < 3)
						win = 0;
			end
				
			//p_sound = erase_e;
			//play_sound2 = 0;
			if( ball_dy > 0 && (ball_x > paddle_x && ball_x < (paddle_x + 100)) && ( ( (ball_y + BALL_SIZE) >= 10'd439 && (ball_y - BALL_SIZE) < 10'd440) ) ) //paddle collision
			begin
				ball_dy = ball_dy * -1;
				play_sound1 = 3'b100;
				if ((ball_x < paddle_x + 25 || ball_x > paddle_x + 75) && (ball_dx == 1 || ball_dx == -1)) begin
					ball_dx = ball_dx * 2;
				end
				else if (ball_dx == 2) begin
					ball_dx = 1;
				end
				else if (ball_dx == -2) begin
					ball_dx = -1;
				end
			end
					
			if (win) begin
				ball_dx = 10'd0;
				ball_dy = 10'd0;
			end

			ball_x = ball_x + ball_dx;
			ball_y = ball_y + ball_dy;
		end

		if(reset)begin
			ball_x = 10'd270;
			ball_y = 10'd440 - BALL_SIZE;
			ball_dx = -10'd1;
			ball_dy = -10'd1;
			start_movement = 0;
			for (i = 0; i < 20; i = i + 1) begin
				active[i] = 0;			
			end
		end
	end
endmodule

