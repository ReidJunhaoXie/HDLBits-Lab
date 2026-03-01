`timescale 1ns/1ps
// 解答是用Case窮舉，但IF就隱含Priority，比較簡潔，或用Boolean expression也可以
// synthesis verilog_input_version verilog_2001
module PriorityCase (
    input [3:0] in,
    output reg [1:0] pos  );
    always@(*) begin
        pos = 2'd0 ;
        if(in[0]==1'b1) pos = 2'd0 ;
        else if(in[1]==1'b1) pos = 2'd1 ;
        else if(in[2]==1'b1) pos = 2'd2 ;
        else if(in[3]==1'b1) pos = 2'd3 ;
        else pos = 2'd0 ;
    end
endmodule
