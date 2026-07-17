`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 15:20:53
// Design Name: 
// Module Name: FIFO_TB
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


module FIFO_TB();

reg clk;
reg reset;


reg we;
reg re;

reg [31:0] data_in;
wire [31:0] data_out;

wire FULL;
wire EMPTY;


FIFO uut(
    .clk(clk),
    .reset(reset),
    .we(we),
    .re(re),
    .data_in(data_in),
    .data_out(data_out),
    .FULL(FULL),
    .EMPTY(EMPTY)
);

always #5 clk = ~clk;

integer i;

initial 
    begin
        clk = 0;
        reset = 1;
        we = 0;
        re = 0;
        data_in = 0;
    
    #20  
    reset = 0;
    
    #5 //data going in to fill fifo to full//
    
    for (i = 0 ; i < 32 ; i = i+1)
        begin
            @(negedge clk)
            we = 1;
            data_in = i + 32'd100000;
        end
        
    @(negedge clk)
    we = 0;
    
    
    
    // overflow test //
    
    @(negedge clk)
    we = 1;
    data_in = 32'd1;
    
    @(negedge clk)
    we = 0;
     
     
       
    // read all data // 
    
    for(i = 0;i < 32; i = i+1)
        begin
            @(negedge clk)
                re = 1;
        end
        
     // underflow test //
     @(negedge clk)
     re = 1;
     
     @(negedge clk)
     re = 0;
     
     // reading and writing at the same time//
     
     @(negedge clk)
     we = 1;
     data_in = 32'd100;
     
     @(negedge clk)
     we = 0;
     
     @(negedge clk)
     we = 1;
     re = 1;
     data_in = 32'd1000;
     
     @(negedge clk)
     we = 0;
     re = 0;
     
     #20;

    $finish;
    end

endmodule
