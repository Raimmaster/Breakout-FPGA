module CollisionDetect(
	input [9:0] block1_x,
	input [9:0] block1_y,
	input [9:0] block1_width,
	input [9:0] block1_height,
	input [9:0] block2_x,
	input [9:0] block2_y,
	input [9:0] block2_width,
	input [9:0] block2_height,
	output collided
	);
	
	reg [9:0] block_a;
	reg [9:0] block_b;
	
	wire [9:0] w_a;
	wire [9:0] w_b;
	wire w_equal;
	wire w_greater;
	wire w_less;

	assign w_a = block_a;
	assign w_b = block_b;
	Compare10 cmp1(w_a, w_b, w_equal, w_greater, w_less);

	always @(*) begin
		
	end


endmodule 