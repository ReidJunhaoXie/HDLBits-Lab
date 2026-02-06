`timescale 1ns/1ps  // time unit / time precision 

module top_tb;
    
    logic clk ; // create clk

    logic t_out;

    initial begin   // Clk Generate
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    always@(posedge clk) begin   // cycle based
        $display("Time: %0t | Output = %b",$time,t_out) ;
    end

    wire_01 dut(
        .out(t_out)
    );

    initial begin
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, top_tb); // 0 means --> all signal of top_tb 

        $display(">>> Simulation Start");
        
        repeat(1) @(posedge clk) ;  // !! 做一次 : 程式hold，直到下一個clk rising edge
        #1;  // delay 1 ps to be away form hold time
        
        if (t_out === 1'b1) 
            $display(">>> Check: PASS (Output is 1)");
        else
            $display(">>> Check: FAIL (Output is %b)", t_out);

        $display(">>> Simulation End");
        $finish; // 結束模擬
    end

endmodule