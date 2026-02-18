`timescale 1ns/1ps

module tb_FullAdder05;

    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] sum;

    logic clk ;

    integer error_count = 0;
    integer loop_cnt;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    FullAdder05 u_dut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    // scoreboard 
    task check_result(input [31:0] in_a, input [31:0] in_b);
        logic [31:0] expected_sum;
        begin
            expected_sum = in_a + in_b; // Golden Modle
            @(posedge clk) ; 
            // Self-Checking
            if (sum !== expected_sum) begin
                $display("[ERROR] Time=%0t | A=0x%h, B=0x%h | Exp=0x%h, Act=0x%h", 
                         $time, in_a, in_b, expected_sum, sum);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin // test data
        $dumpfile("FullAdder05.vcd");
        $dumpvars(0, tb_FullAdder05);

        $display("-----------------------------------------------");
        $display("   STARTING SIMULATION: FullAdder05 Verification");
        $display("-----------------------------------------------");

        // initialize
        a = 0; b = 0;
        @(posedge clk) ;
        // Directed Tests Corner Cases
        $display("--- Phase 1: Directed Corner Cases ---");
        
        // Case 1: zero 
        a = 32'h0; b = 32'h0; 
        check_result(a, b);

        // Case 2: Maximun/overflow 
        a = 32'hFFFF_FFFF; b = 32'h0000_0001; 
        check_result(a, b);

        // Case 3: Boundary 
        // 0x0000_FFFF + 0x0000_0001 
        a = 32'h0000_FFFF; b = 32'h0000_0001;
        check_result(a, b);

        // Case 4:  1
        a = 32'hFFFF_FFFF; b = 32'hFFFF_FFFF;
        check_result(a, b);

        // Constrained Random
        $display("--- Phase 2: Randomized Testing (1000 iter) ---");
        for (loop_cnt = 0; loop_cnt < 1000; loop_cnt = loop_cnt + 1) begin
            a = $urandom();
            b = $urandom();
            check_result(a, b);
        end

        // Final Report
        $display("-----------------------------------------------");
        if (error_count == 0) begin
            $display("   SIMULATION PASSED: All checks successful.");
        end else begin
            $display("   SIMULATION FAILED: Found %0d errors.", error_count);
        end
        $display("-----------------------------------------------");
        
        $finish; 
    end

endmodule