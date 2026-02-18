`timescale 1ns/1ps

module FullAdder05 (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);//
    wire [15:0] sum_a,sum_b ;
    wire cout2 ;
    assign sum = {sum_b,sum_a} ;
    add16 u0(.a(a[15:0]),.b(b[15:0]),.cin(1'b0),.sum(sum_a),.cout(cout2)) ;
    add16 u1(.a(a[31:16]),.b(b[31:16]),.cin(cout2),.sum(sum_b),.cout()) ;
endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );
    
    assign {cout,sum} = a + b + cin ;

endmodule

module add16(input [15:0] a, input [15:0] b, input cin, output [15:0] sum, output cout) ;
    assign {cout,sum} = a + b + cin ;
endmodule
