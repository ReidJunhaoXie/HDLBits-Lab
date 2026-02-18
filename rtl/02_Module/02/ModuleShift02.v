`timescale 1ns/1ps

module ModuleShift02 ( input clk, input d, output q );
    wire q1,q2 ;  // If assgin someing(submodule output) --> wire ; reg --> variable
    my_dff u0(.clk(clk),.d(d),.q(q1)) ;
    my_dff u1(.clk(clk),.d(q1),.q(q2)) ;
    my_dff u2(.clk(clk),.d(q2),.q(q)) ;
endmodule

module my_dff ( input clk, input d, output reg q) ;
    always @(posedge clk) begin
        q <= d ;
    end
endmodule