`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:40 08/25/2024 
// Design Name: 
// Module Name:    sig_control 
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
`define TRUE 1'b1
`define FALSE 1'b0
`define Y2RDELAY 3
`define R2GDELAY 2

module sig_control(hwy,cntry,x,clk,clr);

output reg [1:0] hwy,cntry;
input x,clk,clr;

parameter RED=2'd0,
          YELLOW =2'd1,
			 GREEN=2'd2,
			 S0=3'd0,
			 S1=3'd1,
			 S2=3'd2,
			 S3=3'd3,
			 S4=3'd4;
			 
reg [2:0] PS,NS;

always@(posedge clk)

           if(clr)
              PS<= S0;
           else
              PS<=NS;
				  
 always@(PS)begin
          hwy=GREEN;
          cntry=RED;
     case(PS)
          S0:;//no change 
			 
			 S1:hwy=YELLOW;
			 
			 S2:hwy=RED;
			 
			 S3:begin
			      hwy=RED;
			      cntry=GREEN;
			    end
				 
			 S4:begin
			      hwy=RED;
			      cntry=YELLOW;
			    end
				 
		endcase
	end
	
always@(PS or x)begin
      case(PS)
		
         S0:if(x)
             NS=S1;
            else
             NS=S0;
				 
         S1:begin
              repeat(`Y2RDELAY) @(posedge clk);
              NS=S2;
            end
				
         S2:begin
              repeat(`R2GDELAY) @(posedge clk);
              NS=S3;
            end
				
         S3:if(x)
              NS=S3;
            else
              NS=S4;
				  
         S4:begin
              repeat(`Y2RDELAY) @(posedge clk);
              NS=S0;
            end
				
         default: NS=S0;
			
       endcase
     end
endmodule
