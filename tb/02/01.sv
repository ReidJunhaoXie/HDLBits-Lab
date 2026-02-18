`timescale 1ns/1ps

module CallbyName01_tb;

    reg  a, b, c, d;
    wire out1, out2;
    
    reg  exp_out1, exp_out2;
    
    integer err_cnt = 0;
    integer i;

    logic clk ;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end
    
    CallbyName01 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out1(out1),
        .out2(out2)
    );

    initial begin
        // initialize 
        {a, b, c, d} = 4'b0000;
        $display("---------------------------------------");
        $display("Starting Testbench: CallbyName01");
        $display("Time\t A B C D | Out1 Out2 | Status");
        $display("---------------------------------------");

        // Exhusting test 
        for (i = 0; i < 16; i = i + 1) begin
            {a, b, c, d} = i;
            
            // Golden Model
            exp_out1 = a & b;
            exp_out2 = c & d;

            repeat(1) @(posedge clk) ;

            // Self-checking
            if ((out1 !== exp_out1) || (out2 !== exp_out2)) begin
                $display("%0t\t %b %b %b %b |  %b    %b  | [FAIL] Exp: %b %b", 
                         $time, a, b, c, d, out1, out2, exp_out1, exp_out2);
                err_cnt = err_cnt + 1;
            end else begin
                $display("%0t\t %b %b %b %b |  %b    %b  | [PASS]", 
                         $time, a, b, c, d, out1, out2);
            end
        end

        $display("---------------------------------------");
        if (err_cnt == 0) begin
            $display("TEST PASSED: All combinations verified.");
        end else begin
            $display("TEST FAILED: %0d mismatches found.", err_cnt);
        end
        $display("---------------------------------------");
        $finish;
    end

    initial begin
        $dumpfile("CallbyName01_tb.vcd");
        $dumpvars(0, CallbyName01_tb);
    end

endmodule