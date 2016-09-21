`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:05 12/22/2015 
// Design Name: 
// Module Name:    clockDivider 
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
module clockDivider(clk, select, Nclk);
input clk, select;
output Nclk;
parameter clkdivider = 50000000/25000000/2; // clk-frequency/Nclk-frequency/2: sets Nclk to 25MHz 
parameter clkdivider2 = 25000000; 

reg [25:0] counter;
always @(posedge clk)
	if(select)
		if(counter==0) 
			counter <= clkdivider-1; 
		else 
			counter <= counter-1;
	else
		if(counter==0) 
			counter <= clkdivider2-1; 
		else 
			counter <= counter-1;
			
reg Nclk;
always @(posedge clk) 
	if(counter==0) 
		Nclk <= ~Nclk;
		
endmodule

