`timescale 1ns / 1ps

module Main(
		input clk50mhz,
		output [2:0] RGB,
		output hsync,
		output vsync,
		input clk_audio,
		input right_button,
		input reset_button,
		input mi_nota,
		input left_button
		//output [3:0] tono
    );
	//VGA section
	wire vga_clk;
	wire clk_paddle;
	wire clk_ball;
	wire [2:0] rgb;
	wire hs;
	wire vs;
	
	wire [9:0] hcount; 
	wire [9:0] vcount;
	
	wire [9:0] paddle_pos;
	//ball coordinate
	wire [9:0] ball_x;
	wire [9:0] ball_y;
	wire erase_enable;
	wire [5:0] erase_pos;	
	
	// synthesis attribute CLKFX_DIVIDE of vga_clock_dcm is 4
	// synthesis attribute CLKFX_MULTIPLY of vga_clock_dcm is 2
	DCM vga_clock_dcm (.CLKIN(clk50mhz),.CLKFX(vga_clk));
	
	clk_divider #(.limit(32'h2625A0)) clk_paddle_p (//'
			.clk(clk50mhz),
			.clk_d(clk_paddle)
	);
	
	clk_divider #(.limit(32'h4C4B4)) clk_ball_divider (//'
			.clk(clk50mhz),
			.clk_d(clk_ball)
	);
	//Paddle init
	Paddle pd(left_button, right_button, reset_button, clk_paddle, paddle_pos);
	
	wire [2:0] data;
	wire play_sound1;
	wire play_sound2;
	wire [1:0] active_data;
	//paddle end
	//ball init
	ball bola(paddle_pos, reset_button, clk_ball, ball_x, ball_y, erase_enable, erase_pos, play_sound1, play_sound2, active_data);
		
	VGA vga(vga_clk, rgb, hs, vs, hcount, vcount, data, paddle_pos, ball_x, ball_y, reset_button, erase_enable, erase_pos, active_data);
	
	reg [13:0] address_vga;
	
	assign RGB = rgb;
	assign hsync = hs;
	assign vsync = vs;
	
	//debian_rom d_rom(address_vga, data);
	/*
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
	*/
	////Audio section
	/*
	C	2986 BAA
	D	2660 A64
	E	2369 941
	G	1993 7C9	
	Dividir entre 2 para cambiar de posedge y negedge
	*/
	/*wire clk_out_do;
	wire clk_out_re;
	wire clk_out_mi;
	wire clk_out_sol;
	//do
	clk_divider #(.limit(32'hBAA)) clk_do (
			.clk(clk50mhz),
			.clk_d(clk_out_do)
	);
	
	//re
	clk_divider #(.limit(32'hA64)) clk_re (
			.clk(clk50mhz),
			.clk_d(clk_out_re)
	);
	
	//mi
	clk_divider #(.limit(32'h941)) clk_mi (
			.clk(clk50mhz),
			.clk_d(clk_out_mi)
	);
	
	//sol
	clk_divider #(.limit(32'h7C9)) clk_sol (//'
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
	
	always @ (posedge clk50mhz) begin
			temp = 0;
			if(play_sound1) begin
				temp = clk_out_do;
			end
			
			if(play_sound2) begin
				temp = clk_out_re;
			end
		
	end*/
	/*
	always @()
	begin
		if(reset_button)
			counter_audio = 0;
		case(counter_audio)
			0:
			begin
				temp = clk_out_do;
				counter_audio = counter_audio + 1;
			end
			1:
			begin
				temp = clk_out_re;
				counter_audio = counter_audio + 1;
			end
			2:
			begin			
				temp = clk_out_mi;
				counter_audio = counter_audio + 1;
			end
			3:
			begin
				temp = clk_out_sol;
				counter_audio = 0;
			end
			default:
				begin
					temp = 0;
				end
		endcase
	end*/
endmodule