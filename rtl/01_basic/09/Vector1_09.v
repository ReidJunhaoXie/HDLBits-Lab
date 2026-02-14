`timescale 1ns/1ps

module Vector1_09( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );
    
    assign out_hi = in[15:8] ;
    assign out_lo = in[7:0]  ;
    
endmodule