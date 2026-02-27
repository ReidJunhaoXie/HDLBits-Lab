`timescale 1ns/1ps

module SubAdder07(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire cout ;
    wire [15:0] sum_a, sum_b ;
    wire [31:0] process_b ;
    assign process_b = ({32{sub}} ^ b) + {{31{1'b0}},sub} ;
    assign sum = {sum_b,sum_a} ;
    add16 u0(.a(a[15:0]), .b(process_b[15:0]), .cin(1'b0), .sum(sum_a), .cout(cout)) ;
    add16 u1(.a(a[31:16]), .b(process_b[31:16]), .cin(cout), .sum(sum_b), .cout()) ;
endmodule

module add16(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
) ;
    assign {cout,sum} = a + b + cin ;
endmodule