`timescale 1ns / 1ps
module debian_rom(
	input [13:0] address,
	output reg [2:0] data
    );

	reg [2:0] rom_content[0:16383];
	
	always @(address)
		data = rom_content[address];
		
	initial begin
		//131072
		$readmemh("imagen.mif", rom_content, 0, 16383);
	end

endmodule
