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
	 input reset
);

   reg [9:0] hcount;
   reg [9:0] vcount;
    
	assign hor_count = hcount;
	assign ver_count = vcount;
	 
	reg [9:0] data_x [24:0];
	reg [9:0] data_y [24:0];
	reg active [24:0];
	reg [4:0] i;
	 
    always @ ( posedge CLK_25MH)
    begin 
		  if (reset) begin
			for (i = 0; i < 25; i = i + 1) begin
				if(i < 5) begin
					data_x[i] = 10'd40 + (40 + 80) * i;//10'd40 por lo largo del cuadro
					data_y[i] = 40;
					active[i] = 1;
				end
				else if (i < 10)begin
					data_x[i] = 10'd40 + ((40+80)*(i-5));
					data_y[i] = 110;
					active[i] = 1;
				end
				else if(i < 15) begin
					data_x[i] = 10'd40 + ((40+80)*(i-10));
					data_y[i] = 180;
					active[i] = 1;
				end
				else if (i < 20)begin
					data_x[i] = 10'd40 + ((40+80)*(i-15));
					data_y[i] = 250;
					active[i] = 1;
				end
				else if (i < 25)begin
					data_x[i] = 10'd40 + ((40+80)*(i-20));
					data_y[i] = 320;
					active[i] = 1;
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
            RGB = 3'b000;
				if(vcount > 440 && vcount < 450 && hcount > paddle_pos && hcount < paddle_pos + 100)begin
					RGB = 3'b001;
				end
				else begin
					//first row of blocks (upper)
					if(active[0] && (vcount >= data_y[0] && vcount <= (data_y[0] + 30)) 
						&& hcount >= data_x[0] && hcount <= (data_x[0] + 80))
					begin
						RGB = 3'b010;
					end
					if(active[1] && (vcount >= data_y[1] && vcount <= (data_y[1] + 30)) 
						&& hcount >= data_x[1] && hcount <= (data_x[1] + 80))
					begin
						RGB = 3'b010;
					end
					if(active[2] && (vcount >= data_y[2] && vcount <= (data_y[2] + 30)) 
						&& hcount >= data_x[2] && hcount <= (data_x[2] + 80))
					begin
						RGB = 3'b010;
					end
					if(active[3] && (vcount >= data_y[3] && vcount <= (data_y[3] + 30)) 
						&& hcount >= data_x[3] && hcount <= (data_x[3] + 80))
					begin
						RGB = 3'b010;
					end
					if(active[4] && (vcount >= data_y[4] && vcount <= (data_y[4] + 30)) 
						&& hcount >= data_x[4] && hcount <= (data_x[4] + 80))
					begin
						RGB = 3'b010;
					end
					//second row of blocks
					if(active[5] && (vcount >= data_y[5] && vcount <= (data_y[5] + 30)) 
						&& hcount >= data_x[5] && hcount <= (data_x[5] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[6] && (vcount >= data_y[6] && vcount <= (data_y[6] + 30)) 
						&& hcount >= data_x[6] && hcount <= (data_x[6] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[7] && (vcount >= data_y[7] && vcount <= (data_y[7] + 30)) 
						&& hcount >= data_x[7] && hcount <= (data_x[7] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[8] && (vcount >= data_y[8] && vcount <= (data_y[8] + 30)) 
						&& hcount >= data_x[8] && hcount <= (data_x[8] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[9] && (vcount >= data_y[9] && vcount <= (data_y[9] + 30)) 
						&& hcount >= data_x[9] && hcount <= (data_x[9] + 80))
					begin
						RGB = 3'b110;
					end
					//third row of blocks
					if(active[10] && (vcount >= data_y[10] && vcount <= (data_y[10] + 30)) 
						&& hcount >= data_x[10] && hcount <= (data_x[10] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[11] && (vcount >= data_y[11] && vcount <= (data_y[11] + 30)) 
						&& hcount >= data_x[11] && hcount <= (data_x[11] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[12] && (vcount >= data_y[12] && vcount <= (data_y[12] + 30)) 
						&& hcount >= data_x[12] && hcount <= (data_x[12] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[13] && (vcount >= data_y[13] && vcount <= (data_y[13] + 30)) 
						&& hcount >= data_x[13] && hcount <= (data_x[13] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[14] && (vcount >= data_y[14] && vcount <= (data_y[14] + 30)) 
						&& hcount >= data_x[14] && hcount <= (data_x[14] + 80))
					begin
						RGB = 3'b110;
					end
					//fourth row of blocks
					if(active[15] && (vcount >= data_y[15] && vcount <= (data_y[15] + 30)) 
						&& hcount >= data_x[15] && hcount <= (data_x[15] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[16] && (vcount >= data_y[16] && vcount <= (data_y[16] + 30)) 
						&& hcount >= data_x[6] && hcount <= (data_x[6] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[17] && (vcount >= data_y[17] && vcount <= (data_y[17] + 30)) 
						&& hcount >= data_x[17] && hcount <= (data_x[17] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[18] && (vcount >= data_y[18] && vcount <= (data_y[18] + 30)) 
						&& hcount >= data_x[18] && hcount <= (data_x[18] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[19] && (vcount >= data_y[19] && vcount <= (data_y[19] + 30)) 
						&& hcount >= data_x[19] && hcount <= (data_x[19] + 80))
					begin
						RGB = 3'b110;
					end
					//fifth row of blocks
					if(active[20] && (vcount >= data_y[20] && vcount <= (data_y[20] + 30)) 
						&& hcount >= data_x[20] && hcount <= (data_x[20] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[21] && (vcount >= data_y[21] && vcount <= (data_y[21] + 30)) 
						&& hcount >= data_x[21] && hcount <= (data_x[21] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[22] && (vcount >= data_y[22] && vcount <= (data_y[22] + 30)) 
						&& hcount >= data_x[22] && hcount <= (data_x[22] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[23] && (vcount >= data_y[23] && vcount <= (data_y[23] + 30)) 
						&& hcount >= data_x[23] && hcount <= (data_x[23] + 80))
					begin
						RGB = 3'b110;
					end
					if(active[24] && (vcount >= data_y[24] && vcount <= (data_y[24] + 30)) 
						&& hcount >= data_x[24] && hcount <= (data_x[24] + 80))
					begin
						RGB = 3'b110;
					end
				end
        end
        else begin
            RGB = 3'b000;
        end
    end

endmodule