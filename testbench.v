`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:29:36 06/03/2016 
// Design Name: 
// Module Name:    testbench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module testbench(
    );

	reg clk;
	wire [2:0] rgb;
	wire hsync;
	wire vsync;
	wire [9:0] hcount;
	wire [9:0] vcount; 
	
	VGA v(clk, rgb, hsync, vsync, hcount, vcount);

	initial
		begin
			clk = 1;
		end
		
		always
			begin
				#10 
				clk = !clk;				
			end
endmodule
