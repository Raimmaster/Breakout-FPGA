`timescale 1ns / 1ps
module VGA(
   input CLK_25MH,
	input CLK_50MH,
   output reg [5:0] RGB,
   output reg hsync,
   output reg vsync,
	output [9:0] hor_count,
	output [9:0] ver_count,
	input [2:0] rgb_in,
	input [9:0] paddle_pos,
	input [9:0] ball_x,
	input [9:0] ball_y,
	input reset,
	input active_write_enable,
	input [5:0] active_position,
	input [1:0] active_data
);
	parameter
		BALL_SIZE = 7,
		BLOCK_SPACING_X = 10'd40,
		BLOCK_WIDTH = 10'd80,
		BLOCK_HEIGHT = 10'd30,
		FIRST_ROW_Y = 10'd40,
		SECOND_ROW_Y = 10'd90,		
		THIRD_ROW_Y = 10'd140,
		FOURTH_ROW_Y = 10'd190,
		FIFTH_ROW_Y = 10'd240;
		
	reg [9:0] hcount;
	reg [9:0] vcount;
    
	assign hor_count = hcount;
	assign ver_count = vcount;
	 
	reg [9:0] data_x [19:0];
	reg [9:0] data_y [19:0];
	reg [2:0] active [19:0];
	reg [4:0] i;
	
	reg [5:0] block_colors [24:0];
	
	always @ (posedge CLK_50MH) begin
		if(active_write_enable)
			active[active_position] = active_data;
			
		if (reset) begin
		  	//initialize rows and columns of block
			for (i = 0; i < 20; i = i + 1) begin
				if(i < 5) begin
					data_x[i] = BLOCK_SPACING_X + (BLOCK_SPACING_X + BLOCK_WIDTH) * i;
					data_y[i] = FIRST_ROW_Y;
					block_colors[i] = 6'b001001;
					active[i] = 0;
				end
				else if (i < 10) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-5));
					data_y[i] = SECOND_ROW_Y;					
					block_colors[i] = 6'b010101;
					active[i] = 0;
				end
				else if (i < 15) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-10));
					data_y[i] = THIRD_ROW_Y;					
					block_colors[i] = 6'b010101;
					active[i] = 0;
				end
				else if (i < 20) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-15));
					data_y[i] = FOURTH_ROW_Y;					
					block_colors[i] = 6'b010101;
					active[i] = 0;
				end
				else if (i < 25) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-20));
					data_y[i] = FIFTH_ROW_Y;					
					block_colors[i] = 6'b010101;
					active[i] = 0;
				end
				
			end
		end
	end

    always @ ( posedge CLK_25MH)
    begin 
      if (hcount == 799) begin
            hcount = 0;
            if (vcount == 524) begin
                vcount = 0;
				end
            else begin
                vcount = vcount + 1;
            end
			end
        else begin
            hcount = hcount + 1;
        end

        if (vcount >= 490 && vcount < 492) begin
            vsync = 0;
        end
        else begin
            vsync = 1;
        end

        if (hcount >= 656 && hcount < 752) begin
            hsync = 0;
        end
        else begin
            hsync = 1;
        end

        if (hcount < 640 && vcount < 480) begin
            RGB = 6'b000;//'

        		if(vcount >= ball_y && vcount <= (ball_y + BALL_SIZE)//ball
        			&& hcount >= ball_x && hcount <= (ball_x + BALL_SIZE) )
        			RGB = 6'b111000;//'

				if(vcount > 440 && vcount < 450 && 
					hcount > paddle_pos && hcount < paddle_pos + 100)begin//paddle
					RGB = 6'b100001;//'
				end
				else begin
				for (i = 0; i < 20; i = i + 1) begin
					//first row of blocks (upper)
					//if(i < 5)begin
						if(active[i] != 2'b11 && (vcount >= data_y[i] && vcount <= (data_y[i] + BLOCK_HEIGHT)) 
							&& hcount >= data_x[i] && hcount <= (data_x[i] + BLOCK_WIDTH))
						begin
							RGB = block_colors[i] + active[i] + 6'b000001;
						end
					/*
					end
					else begin
						//second row of blocks
						if(active[i] != 2'b11 && (vcount >= data_y[i] && vcount <= (data_y[i] + BLOCK_HEIGHT)) 
							&& hcount >= data_x[i] && hcount <= (data_x[i] + BLOCK_WIDTH))
						begin
							RGB = block_colors[i] + active[i] + 6'b000001;
						end
					end
					*/
				end
				end
        end
        else begin
            RGB = 6'b000;
        end
    end

endmodule