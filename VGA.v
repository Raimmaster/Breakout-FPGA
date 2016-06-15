`timescale 1ns / 1ps
module VGA(
    input CLK_25MH,
    output reg [2:0] RGB,
    output reg hsync,
    output reg vsync,
	 output [9:0] hor_count,
	 output [9:0] ver_count,
	 input [2:0] rgb_in,
	 input [9:0] paddle_pos
);

    reg [9:0] hcount;
    reg [9:0] vcount;
    
	 assign hor_count = hcount;
	 assign ver_count = vcount;
	 
	 
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
            RGB = 3'b000;
				if(vcount > 440 && vcount < 450 && hcount > paddle_pos && hcount < paddle_pos + 100)begin
					RGB = 3'b100;
				end
        end
        else begin
            RGB = 3'b000;
        end
    end

endmodule