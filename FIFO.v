`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 06:39:00
// Design Name: 
// Module Name: FIFO
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


module FIFO(
input clk,
input reset,

input we,
input re,

input [31:0] data_in,
output reg [31:0] data_out,

output FULL,
output EMPTY
    );
    
    parameter DEPTH = 32;
    parameter ADDR_WIDTH = 5;
    
    
    reg [31:0] mem[0:DEPTH-1];
    reg [ADDR_WIDTH - 1:0] w_pt;
    reg [ADDR_WIDTH - 1:0] r_pt;
    
    reg [5:0] count;
    
    assign FULL = (count == DEPTH);
    assign EMPTY = (count == 0);
    
    always@(posedge clk or posedge reset)
        begin
            if(reset)
                begin
                    count <= 0;
                    w_pt <= 0;
                    r_pt <= 0;
                    data_out <= 0;
                end
            else begin
            if (we && !FULL)
                begin
                    mem[w_pt] <= data_in;
                    w_pt <= w_pt + 1;
                end
            if (re && !EMPTY)
                begin
                    data_out <= mem[r_pt];
                    r_pt <= r_pt + 1;
                end
            
            case({we && !FULL,re && !EMPTY})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                2'b11: count <= count;
                default: count <= count;
           endcase
           end
        end      
endmodule
