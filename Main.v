`timescale 1ns / 1ps

module Main(
		input clk50mhz,
		output [2:0] RGB,
		output hsync,
		output vsync
    );

	wire vga_clk;
	wire [2:0] rgb;
	wire hs;
	wire vs;
	
	wire [9:0] hcount; 
	wire [9:0] vcount;
	
	// synthesis attribute CLKFX_DIVIDE of vga_clock_dcm is 4
	// synthesis attribute CLKFX_MULTIPLY of vga_clock_dcm is 2
	DCM vga_clock_dcm (.CLKIN(clk50mhz),.CLKFX(vga_clk));
	
	
	wire [2:0] data;
	
	
	VGA vga(vga_clk, rgb, hs, vs, hcount, vcount, data);
	
	reg [13:0] address;
	
	debian_rom d_rom(address, data);
	
	always @(posedge vga_clk)
		begin
			if(vcount < 100)begin
				if(hcount < 100) begin
					address = address + 1;
				end
			end
			else begin
				address = 0;
			end
		end
	
	assign RGB = rgb;
	assign hsync = hs;
	assign vsync = vs;
endmodule
