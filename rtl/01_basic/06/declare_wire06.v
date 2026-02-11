`timescale 1ns/1ps
module declare_wire06(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
    assign out = (a&b)|(c&d) ;
    assign out_n = ~out ;
endmodule
