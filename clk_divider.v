module clk_divider(
    input clk,
    output clk_d
);

    parameter 
		limit = 12'hbaa;
    
	 reg [21:0] counter;
	 reg clk_buf;
	 assign clk_d = clk_buf;
	 
    always @ (posedge clk) begin
        counter = counter + 1;
        
        if(counter == (limit / 2) ) begin
            clk_buf = !clk_buf;
            counter = 22'h0;
        end
    end
endmodule
