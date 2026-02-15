`timescale 1ns/1ps

module Vector4_partselection_12(
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );//
    wire [31:0] temp ;
    assign temp = {a,b,c,d,e,f,1'b1,1'b1} ;
    assign {w,x,y,z} = temp ;
endmodule