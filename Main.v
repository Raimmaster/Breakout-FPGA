`timescale 1ns / 1ps

module Main(
		input clk50mhz,
		output [2:0] RGB,
		output hsync,
		output vsync,
		input clk_audio,
		input do_nota,
		input re_nota,
		input mi_nota,
		input sol_nota,
		
		output [3:0] tono
    );
	//VGA section
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
	
	reg [13:0] address_vga;
	
	debian_rom d_rom(address_vga, data);
	
	always @(posedge vga_clk)
		begin
			if(vcount < 100)begin
				if(hcount < 100) begin
					address_vga = address_vga + 1;
				end
			end
			else begin
				address_vga = 0;
			end
		end
	
	assign RGB = rgb;
	assign hsync = hs;
	assign vsync = vs;
	
	//Audio section
	/*
	C	2986 BAA
	D	2660 A64
	E	2369 941
	G	1993 7C9
	
	Dividir entre 2 para cambiar de posedge y negedge
*/
	wire clk_out_do;
	wire clk_out_re;
	wire clk_out_mi;
	wire clk_out_sol;
	//do
	clk_divider #(.limit(12'hBAA)) clk_do (
			.clk(clk50mhz),
			.clk_d(clk_out_do)
	);
	
	//re
	clk_divider #(.limit(12'hA64)) clk_re (
			.clk(clk50mhz),
			.clk_d(clk_out_re)
	);
	
	//mi
	clk_divider #(.limit(12'h941)) clk_mi (
			.clk(clk50mhz),
			.clk_d(clk_out_mi)
	);
	
	//sol
	clk_divider #(.limit(12'h7C9)) clk_sol (
			.clk(clk50mhz),
			.clk_d(clk_out_sol)
	);
	
	
	wire clk_actual;
	reg [4:0] address_audio;
	reg temp;
	assign clk_actual = temp;
	
	sinewave_rom_do rom_tono(address_audio, tono);


	always @(posedge clk_actual) 
	begin
		address_audio = address_audio + 1;
	end	
	
	always @(do_nota or re_nota or mi_nota or sol_nota)
	begin
		case(1)
			do_nota:
			begin
				temp = clk_out_do;
			end
			re_nota:
			begin
				temp = clk_out_re;
			end
			mi_nota:
			begin			
				temp = clk_out_mi;
			end
			sol_nota:
			begin
				temp = clk_out_sol;
			end
			default:
				begin
					temp = 0;
				end
		endcase
	end
endmodule
