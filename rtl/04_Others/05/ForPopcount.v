// 記得initialize

module ForPopcount( 
    input [254:0] in,
    output reg [7:0] out );
    
    integer i ;
    always@(*) begin
        out = 8'd0 ;
        for(i=0;i<255;i++) begin
            if(in[i]==1'b1) out = out + 8'd1 ;
        end
    end
endmodule