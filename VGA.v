`timescale 1ns / 1ps
module VGA(
   input CLK_25MH,
   output reg [2:0] RGB,
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
	 
	reg [9:0] data_x [9:0];
	reg [9:0] data_y [9:0];
	reg [2:0] active [9:0];
	reg [4:0] i;
	 
    always @ ( posedge CLK_25MH)
    begin 
		if(active_write_enable)
			active[active_position] = active_data;
		
		if (reset) begin
		  	//initialize rows and columns of block
			for (i = 0; i < 10; i = i + 1) begin
				if(i < 5) begin
					data_x[i] = BLOCK_SPACING_X + (BLOCK_SPACING_X + BLOCK_WIDTH) * i;
					data_y[i] = FIRST_ROW_Y;
					active[i] = 0;
				end
				else if (i < 10) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-5));
					data_y[i] = SECOND_ROW_Y;
					active[i] = 0;
				end
			end
		end
       else if (hcount == 799) begin
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
            RGB = 3'b000;//'

        		if(vcount >= ball_y && vcount <= (ball_y + BALL_SIZE)//ball
        			&& hcount >= ball_x && hcount <= (ball_x + BALL_SIZE) )
        			RGB = 3'b101;//'

				if(vcount > 440 && vcount < 450 && 
					hcount > paddle_pos && hcount < paddle_pos + 100)begin//paddle
					RGB = 3'b001;//'
				end
				else begin
				for (i = 0; i < 10; i = i + 1) begin
					//first row of blocks (upper)
					if(i < 5)begin
						if(active[i] != 2'b11 && (vcount >= data_y[i] && vcount <= (data_y[i] + BLOCK_HEIGHT)) 
							&& hcount >= data_x[i] && hcount <= (data_x[i] + BLOCK_WIDTH))
						begin
							RGB = 3'b010;//'
						end
					end
					else begin
						//second row of blocks
						if(active[i] != 2'b11 && (vcount >= data_y[i] && vcount <= (data_y[i] + BLOCK_HEIGHT)) 
							&& hcount >= data_x[i] && hcount <= (data_x[i] + BLOCK_WIDTH))
						begin
							RGB = 3'b110;//'
						end
					end
				end
				end
        end
        else begin
            RGB = 3'b000;
        end
    end

endmodule