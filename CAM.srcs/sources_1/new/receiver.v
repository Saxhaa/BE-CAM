`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 05:10:40 PM
// Design Name: 
// Module Name: receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module receiver(
    input CLK,
    input RBYTEP,
    input RENABLE,
    input TABORTP,
    input RESET,
    input [7:0] RADATAI,
    input [7:0] TDATA,
    output RCLEANP,
    output RSMATIP,
    output RSTARTP,
    output [7:0] RDATA
    );
endmodule
