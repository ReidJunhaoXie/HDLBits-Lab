`timescale 1ns/1ps

module Vector_Advance_duplicate (
    input a, b, c, d, e,
    output [24:0] out );//
    wire [24:0] comb_A, comb_B ;
   
    assign comb_A = {5{a,b,c,d,e}} ;
    assign comb_B = {{5{a}},{5{b}},{5{c}},{5{d}},{5{e}}} ;
    assign out = ~comb_A ^ comb_B ;

endmodule