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
	 input erase_enable,
	 input [5:0] erase_pos
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
		
	reg c_a;
	reg c_b;
	
	wire w_a;
	wire w_b;
	wire w_e;
	wire w_g;
	wire w_l;
	assign w_a = c_a;
	assign w_b = c_b;
	Compare10 cmp1(w_a, w_b, w_e, w_g, w_l);

   reg [9:0] hcount;
   reg [9:0] vcount;
    
	assign hor_count = hcount;
	assign ver_count = vcount;
	 
	reg [9:0] data_x [11:0];
	reg [9:0] data_y [11:0];
	reg active [11:0];
	reg [4:0] i;
	 
    always @ ( posedge CLK_25MH)
    begin 
			if(erase_enable)
				active[erase_pos] = 0;
		  if (reset) begin
		  //initialize rows and columns of block
			for (i = 0; i < 12; i = i + 1) begin
				if(i < 5) begin
					data_x[i] = BLOCK_SPACING_X + (BLOCK_SPACING_X + BLOCK_WIDTH) * i;
					data_y[i] = FIRST_ROW_Y;
					active[i] = 1;
				end
				else if (i < 10) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-5));
					data_y[i] = SECOND_ROW_Y;
					active[i] = 1;
				end
				else if(i == 10) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (11-10));
					data_y[i] = THIRD_ROW_Y;
					active[i] = 1;
				end
				else if (i == 11) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (13-10));
					data_y[i] = THIRD_ROW_Y;
					active[i] = 1;
				end/*
				else if (i < 25) begin
					data_x[i] = BLOCK_SPACING_X + ((BLOCK_SPACING_X + BLOCK_WIDTH) * (i-20));
					data_y[i] = FIFTH_ROW_Y;
					active[i] = 1;
				end	 */
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
					//first row of blocks (upper)
					if(active[0] && (vcount >= data_y[0] && vcount <= (data_y[0] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[0] && hcount <= (data_x[0] + BLOCK_WIDTH))
					begin
						RGB = 3'b010;//'
					end
					if(active[1] && (vcount >= data_y[1] && vcount <= (data_y[1] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[1] && hcount <= (data_x[1] + BLOCK_WIDTH))
					begin
						RGB = 3'b010;//'
					end
					if(active[2] && (vcount >= data_y[2] && vcount <= (data_y[2] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[2] && hcount <= (data_x[2] + BLOCK_WIDTH))
					begin
						RGB = 3'b010;//'
					end
					if(active[3] && (vcount >= data_y[3] && vcount <= (data_y[3] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[3] && hcount <= (data_x[3] + BLOCK_WIDTH))
					begin
						RGB = 3'b010;//'
					end
					if(active[4] && (vcount >= data_y[4] && vcount <= (data_y[4] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[4] && hcount <= (data_x[4] + BLOCK_WIDTH))
					begin
						RGB = 3'b010;//'
					end
					//second row of blocks
					if(active[5] && (vcount >= data_y[5] && vcount <= (data_y[5] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[5] && hcount <= (data_x[5] + BLOCK_WIDTH))
					begin
						RGB = 3'b110;//'
					end
					if(active[6] && (vcount >= data_y[6] && vcount <= (data_y[6] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[6] && hcount <= (data_x[6] + BLOCK_WIDTH))
					begin
						RGB = 3'b110;//'
					end
					if(active[7] && (vcount >= data_y[7] && vcount <= (data_y[7] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[7] && hcount <= (data_x[7] + BLOCK_WIDTH))
					begin
						RGB = 3'b110;//'
					end
					if(active[8] && (vcount >= data_y[8] && vcount <= (data_y[8] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[8] && hcount <= (data_x[8] + BLOCK_WIDTH))
					begin
						RGB = 3'b110;//'
					end
					if(active[9] && (vcount >= data_y[9] && vcount <= (data_y[9] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[9] && hcount <= (data_x[9] + BLOCK_WIDTH))
					begin
						RGB = 3'b110;
					end
					if(active[10] && (vcount >= data_y[10] && vcount <= (data_y[10] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[10] && hcount <= (data_x[10] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					if(active[11] && (vcount >= data_y[11] && vcount <= (data_y[11] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[11] && hcount <= (data_x[11] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					/*
					//third row of blocks
					if(active[10] && (vcount >= data_y[10] && vcount <= (data_y[10] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[10] && hcount <= (data_x[10] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					if(active[11] && (vcount >= data_y[11] && vcount <= (data_y[11] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[11] && hcount <= (data_x[11] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					if(active[12] && (vcount >= data_y[12] && vcount <= (data_y[12] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[12] && hcount <= (data_x[12] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					if(active[13] && (vcount >= data_y[13] && vcount <= (data_y[13] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[13] && hcount <= (data_x[13] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					if(active[14] && (vcount >= data_y[14] && vcount <= (data_y[14] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[14] && hcount <= (data_x[14] + BLOCK_WIDTH))
					begin
						RGB = 3'b111;
					end
					//fourth row of blocks
					if(active[15] && (vcount >= data_y[15] && vcount <= (data_y[15] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[15] && hcount <= (data_x[15] + BLOCK_WIDTH))
					begin
						RGB = 3'b100;
					end
					if(active[16] && (vcount >= data_y[16] && vcount <= (data_y[16] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[6] && hcount <= (data_x[6] + BLOCK_WIDTH))
					begin
						RGB = 3'b100;
					end
					if(active[17] && (vcount >= data_y[17] && vcount <= (data_y[17] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[17] && hcount <= (data_x[17] + BLOCK_WIDTH))
					begin
						RGB = 3'b100;
					end
					if(active[18] && (vcount >= data_y[18] && vcount <= (data_y[18] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[18] && hcount <= (data_x[18] + BLOCK_WIDTH))
					begin
						RGB = 3'b100;
					end
					if(active[19] && (vcount >= data_y[19] && vcount <= (data_y[19] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[19] && hcount <= (data_x[19] + BLOCK_WIDTH))
					begin
						RGB = 3'b100;
					end
					//fifth row of blocks
					if(active[20] && (vcount >= data_y[20] && vcount <= (data_y[20] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[20] && hcount <= (data_x[20] + BLOCK_WIDTH))
					begin
						RGB = 3'b011;
					end
					if(active[21] && (vcount >= data_y[21] && vcount <= (data_y[21] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[21] && hcount <= (data_x[21] + BLOCK_WIDTH))
					begin
						RGB = 3'b011;
					end
					if(active[22] && (vcount >= data_y[22] && vcount <= (data_y[22] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[22] && hcount <= (data_x[22] + BLOCK_WIDTH))
					begin
						RGB = 3'b011;
					end
					if(active[23] && (vcount >= data_y[23] && vcount <= (data_y[23] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[23] && hcount <= (data_x[23] + BLOCK_WIDTH))
					begin
						RGB = 3'b011;
					end
					if(active[24] && (vcount >= data_y[24] && vcount <= (data_y[24] + BLOCK_HEIGHT)) 
						&& hcount >= data_x[24] && hcount <= (data_x[24] + BLOCK_WIDTH))
					begin
						RGB = 3'b011;
					end*/
				end
        end
        else begin
            RGB = 3'b000;
        end
    end

endmodule