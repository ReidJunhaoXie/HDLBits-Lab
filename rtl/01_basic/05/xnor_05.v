`timescale 1ns/1ps
module xnor_05(
   input a,
   input b,
   output out 
);
    assign out = a ~^ b ;
    
endmodule 