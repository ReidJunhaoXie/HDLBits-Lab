module n_wire_03(
    input a,b,c,
    output w,x,y,z
    ) ;
    assign {w,x,y,z} = {a,b,b,c} ;
endmodule