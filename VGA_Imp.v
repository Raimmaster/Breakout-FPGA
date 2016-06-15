module VGA_Imp (  
  input clk,
  input red,
  input green,
  input blue,
  output reg hsync,
  output reg vsync
);
 
wire vga_clk;
 
DCM vga_clk_dcm (.CLKIN (clk50mhz),
                .CLKFX(vga_clk));
					 
 reg hcount = 0;
 reg vcount = 0;
 //cada 40 ns, 1 / 25,000,000 segs
  always @(posedge vga_clk_dcm)  
    begin  
      if (hcount == 799)
			begin
          hcount = 0;
          if (vcount == 524) 
            vcount = 0;
          else
              vcount = vcount + 1;
			end
      else
        hcount = hcount + 1;

      if (vcount >= 490 && vcount < 492)
        vsync = 0;
      else
        vsync = 1;
      

      if (hcount >= 656 && hcount < 752)
        hsync = 0;
      else
        hsync = 1;

      if (hcount < 640 && vcount < 480)
        VGA_Imp(0, 1, 0);
      else
        VGA_Imp(0, 0, 0); 
    end  
endmodule