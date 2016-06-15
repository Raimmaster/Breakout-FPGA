module clk_divider(
    input clk,
    output clk_d
);

    parameter 
		limit = 32'hbaa;
    
	 reg [31:0] counter;
	 reg clk_buf;
	 assign clk_d = clk_buf;
	 
    always @ (posedge clk) begin
        counter = counter + 1;
        
        if(counter == (limit / 2) ) begin
            clk_buf = !clk_buf;
            counter = 32'h0;
        end
    end
endmodule
