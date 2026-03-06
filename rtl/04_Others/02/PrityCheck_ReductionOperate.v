`timescale 1ns/1ps

module ParityCheck_ReductionOperator (
    input [7:0] in,
    output parity); 
    assign parity = ^in[7:0] ;
endmodule
