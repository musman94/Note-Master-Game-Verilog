`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:15 12/22/2015 
// Design Name: 
// Module Name:    mainModule 
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
module mainModule(input clk,rst,b1,b2,b3,b4,output reg CA,CB,CC,CD,CE,CF,CG,AN3,AN2,AN1,AN0,l1,l2,l3,l4,press,sound
    );
// audio 	 
reg[1:0] aud_state, aud_nextState;
parameter aud0 = 0, aud1 = 01, aud2= 10, aud_select = 1;	

clockDivider sc1( clk, aud_select, newClk); // newClk is 25 MHz

music music_one( newClk, speaker); 

always@(posedge clk)
		aud_state <= aud_nextState;
		
reg [26:0] aud_counter;
always@(press)
	case(aud_state)
		 aud0: if(press)
					aud_nextState = aud1;
				 else
					aud_nextState = aud0;
		 aud1: aud_nextState = aud2;
		 aud2: if(aud_counter < 75000000)
					aud_nextState = aud2;
				 else
					aud_nextState = aud0;	
		 default: aud_nextState = aud0;			
	endcase

always@(aud_state)
  case(aud_state)
		aud0: sound = 0;
		aud1: sound = speaker;
		aud2: begin
				sound = speaker;
				aud_counter <= aud_counter + 1;
				end				
  endcase	

// display   
reg X;
reg [25:0] counter;
reg [3:0] select;
reg [3:0] bt,nextbt;
reg [2:0] bt_check;
parameter B0 = 0, B1 = 1, B2 = 2, B3 = 3, B4 = 4;
always@(bt)
begin
case(bt)
B0: 
begin
l1 <= 0;
l2 <= 0;
l3 <= 0;
l4 <= 0;
bt_check <= 0;
end
B1: 
begin
l1 <= 1;
l2 <= 0;
l3 <= 0;
l4 <= 0;
bt_check <= 1;
end
B2: 
begin
l1 <= 0;
l2 <= 1;
l3 <= 0;
l4 <= 0;
bt_check <= 2;
end
B3: 
begin
l1 <= 0;
l2 <= 0;
l3 <= 1;
l4 <= 0;
bt_check <= 3;
end
B4: 
begin
l1 <= 0;
l2 <= 0;
l3 <= 0;
l4 <= 1;
bt_check <= 4;
end
endcase
end
always@(b1,b2,b3,b4)
begin
if(b1 == 1)
nextbt <= B1;
if(b2 == 1)
nextbt <= B2;
if(b3 == 1)
nextbt <= B3;
if(b4 == 1)
nextbt <= B4;
if(b1 == 0 && b2 == 0 && b3 == 0 && b4 ==0)
nextbt <= B0;
end
always@(posedge clk)
begin
if(rst == 1)
bt <= B0;
else
bt <= nextbt;
end

always @(posedge clk)
begin
if(counter < 50000000)
begin
counter <= counter + 1;
X <= 0;
end
else
begin
counter <= 26'b0;
X <= 1;
select = select + 1;
end
end
parameter S1 = 1, S2 = 2, S3 = 3, S4 = 4;
reg [3:0]state, nextstate;
reg [2:0]check;
initial 
state <= S1;
always @(state)
begin
case(state)
S1:
begin
CA <= 1;
CB <= 0;
CC <= 0;
CD <= 1;
CE <= 1;
CF <= 1;
CG <= 1;
AN3 <= 1;
AN2 <= 1;
AN1 <= 1;
AN0 <= 0;
check <= 1;
end
S2:
begin
CA <= 0;
CB <= 0;
CC <= 0;
CD <= 1;
CE <= 0;
CF <= 0;
CG <= 1;
AN3 <= 1;
AN2 <= 1;
AN1 <= 0;
AN0 <= 1;
check <= 2;
end
S3:
begin
CA <= 0;
CB <= 0;
CC <= 0;
CD <= 0;
CE <= 1;
CF <= 1;
CG <= 0;
AN3 <= 1;
AN2 <= 0;
AN1 <= 1;
AN0 <= 1;
check <= 3;
end
S4:
begin
CA <= 1;
CB <= 0;
CC <= 0;
CD <= 1;
CE <= 1;
CF <= 0;
CG <= 0;
AN3 <= 0;
AN2 <= 1;
AN1 <= 1;
AN0 <= 1;
check <= 4;
end

endcase
end
always@(select)
begin
case(select)
4'b0000 : nextstate <= S1;
4'b0001 : nextstate <= S3;
4'b0010 : nextstate <= S4;
4'b0011 : nextstate <= S2;
4'b0100 : nextstate <= S4;
4'b0101 : nextstate <= S1;
4'b0110 : nextstate <= S2;
4'b0111 : nextstate <= S4;
4'b1000 : nextstate <= S3;
4'b1001 : nextstate <= S2;
4'b1011 : nextstate <= S4;
4'b1100 : nextstate <= S1;
4'b1101 : nextstate <= S4;
4'b1110 : nextstate <= S2;
4'b1111 : nextstate <= S1;
endcase
end

always@ (posedge X)
begin
if(rst == 1)
state <= S1;
else
state <= nextstate;
end
parameter P0 = 0, P1 = 1;
reg p,p_next;
initial
p <= P0; 
always@(p)
begin
case(p)
P0: press <= 0;
P1: press <= 1;
endcase
end
always@(state,bt)
begin
if(check == bt_check)
p_next <= P1;
else
p_next <= P0;
end
always@(posedge clk)
begin
if(rst == 1)
p <= P0;
else
p <= p_next;
end

endmodule


