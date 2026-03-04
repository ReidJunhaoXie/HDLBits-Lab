`timescale 1ns/1ps

module DefaultValue08 (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up  ); 
    always@(*) begin
        {left,down,right,up} = {1'b0,1'b0,1'b0,1'b0} ;
        case(scancode)
            16'he06b : {left,down,right,up} = {1'b1,1'b0,1'b0,1'b0} ;
            16'he072 : {left,down,right,up} = {1'b0,1'b1,1'b0,1'b0} ;
            16'he074 : {left,down,right,up} = {1'b0,1'b0,1'b1,1'b0} ;
            16'he075 : {left,down,right,up} = {1'b0,1'b0,1'b0,1'b1} ;
            default : {left,down,right,up} = {1'b0,1'b0,1'b0,1'b0} ;
        endcase
    end
endmodule
