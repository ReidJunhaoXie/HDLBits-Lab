`timescale 1ns/1ps

module GenerateForRCA( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    genvar i ;
   
    generate 
        assign {cout[0],sum[0]} = a[0] + b[0] + cin ;
        for(i=1;i<100;i=i+1) begin : RCA100
            assign {cout[i],sum[i]} = a[i] + b[i] + cout[i-1] ; 
        end
    endgenerate
endmodule
