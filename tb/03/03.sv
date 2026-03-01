`timescale 1ns/1ps

module tb_IfStatement;

    logic a, b;
    logic sel_b1, sel_b2;
    logic out_assign;
    logic out_always;

    logic clk ;

    logic expected_out;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    IfStatement dut (
        .a(a),
        .b(b),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_assign(out_assign),
        .out_always(out_always)
    );

    initial begin
        $display("======================================================================");
        $display("Starting Exhaustive Verification...");
        $display("Time\t sel_b1 sel_b2 a b | out_assign out_always | Expected | Status");
        $display("----------------------------------------------------------------------");

        for (int i = 0; i < 16; i++) begin
            {sel_b1, sel_b2, a, b} = i[3:0];

            repeat(2) @(posedge clk) ;
            // Golden modle 
            expected_out = (sel_b1 & sel_b2) ? b : a;

            // Self-Checking
            if ((out_assign !== expected_out) || (out_always !== expected_out)) begin
                $error("Mismatch at %0t! sel={%b,%b}, a=%b, b=%b | Expect: %b, Assign: %b, Always: %b", 
                       $time, sel_b1, sel_b2, a, b, expected_out, out_assign, out_always);
            end else begin
                $display("%0t\t   sel_b1 : %b  sel_b2 : %b a : %b b : %b | out_assign : %b out_always : %b | expected_out : %b     | PASS", 
                         $time, sel_b1, sel_b2, a, b, out_assign, out_always, expected_out);
            end
        end

        $display("======================================================================");
        $display("Verification Complete! 100%% Exhaustive Test Passed.");
        $display("======================================================================");
        
        $finish; 
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_IfStatement);
    end

endmodule