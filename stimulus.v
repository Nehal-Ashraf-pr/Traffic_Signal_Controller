`timescale 1ns / 1ps

`define FALSE 1'b0
`define TRUE 1'b1

module stimulus;

	// Inputs
	reg CAR_ON_CNTRY_RD;
	reg clk;
	reg clr;

	// Outputs
	wire [1:0] MAIN_SIG;
	wire [1:0] CNTRY_SIG;

	// Instantiate the Unit Under Test (UUT)
	sig_control uut (
		.hwy(MAIN_SIG), 
		.cntry(CNTRY_SIG), 
		.x(CAR_ON_CNTRY_RD), 
		.clk(clk), 
		.clr(clr)
	);

	// Display Signal States
	initial begin
	   $monitor("\n       RED = 00 , YELLOW = 01 , GREEN = 10       \n");
	end
	
	// Monitor Output Changes
	initial begin
		$monitor($time, "   Main Sig = %b Country Sig = %b Car on Country Road = %b", 
		         MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);
	end
	
	// Generate Clock Signal
	initial begin
		clk = `FALSE;
		forever #5 clk = ~clk;  // 10ns clock cycle (5ns high, 5ns low)
	end
	
	// Reset Sequence
	initial begin
		clr = `TRUE;
		repeat(5) @(negedge clk);
		clr = `FALSE;
	end
	
	// Test Sequence for Car Arrival on Country Road
	initial begin
		CAR_ON_CNTRY_RD = `FALSE;
		
		repeat(20) @(negedge clk); CAR_ON_CNTRY_RD = `TRUE;
		repeat(10) @(negedge clk); CAR_ON_CNTRY_RD = `FALSE;
		
		repeat(20) @(negedge clk); CAR_ON_CNTRY_RD = `TRUE;
		repeat(10) @(negedge clk); CAR_ON_CNTRY_RD = `FALSE;
		
		repeat(20) @(negedge clk); CAR_ON_CNTRY_RD = `TRUE;
		repeat(10) @(negedge clk); CAR_ON_CNTRY_RD = `FALSE;
		
		repeat(10) @(negedge clk);
		$stop;  // End Simulation
	end

endmodule
