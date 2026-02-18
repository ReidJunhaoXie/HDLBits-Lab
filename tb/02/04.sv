`timescale 1ns/1ps

module tb_add1_04;

    logic [31:0] a;
    logic [31:0] b;
    wire  [31:0] sum;

    integer error_cnt = 0;
    integer pass_cnt  = 0;

    add1_04 dut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    logic [31:0] expected_sum;
    assign expected_sum = a + b;

    task verify_result(input string test_name);
        #1; // Combinational Delay
        
        if (sum !== expected_sum) begin
            $display("[FAIL] Time=%0t | %s | Inputs: A=%h, B=%h | DUT Sum=%h | Exp Sum=%h", 
                     $time, test_name, a, b, sum, expected_sum);
            error_cnt++;
        end else begin
            pass_cnt++;
        end
    endtask

    initial begin
        $display("==================================================");
        $display("    STARTING TESTBENCH FOR add1_04 (32-bit Adder)");
        $display("==================================================");

        //  Case 1: Basic Sanity Check
        a = 32'd0; b = 32'd0;
        verify_result("Sanity: Zero");

        a = 32'd10; b = 32'd20;
        verify_result("Sanity: Small Num");

        //  Case 2: Cross-Boundary Carry Test 
        a = 32'h0000_FFFF; 
        b = 32'h0000_0001;
        // expected outcome : 0x0001_0000
        verify_result("Corner: Low16 Carry Output");

        // Case 3: Max Value / Overflow Test 
        a = 32'hFFFF_FFFF; 
        b = 32'h0000_0001;
        // expected outcome  : 0x0000_0000
        verify_result("Corner: 32-bit Overflow");

        a = 32'hFFFF_FFFF; 
        b = 32'hFFFF_FFFF;
        verify_result("Corner: Max + Max");

        // Case 4: Random Regression 
        // x 1000 
        $display("--- Starting Random Regression (1000 iterations) ---");
        repeat (1000) begin
            a = $urandom(); 
            b = $urandom();
            verify_result("Random");
        end

        // 6. Final Report
        $display("==================================================");
        if (error_cnt == 0) begin
            $display("    ALL TESTS PASSED! Total: %0d", pass_cnt);
        end else begin
            $display("    TEST FAILED! Errors: %0d / Total: %0d", error_cnt, pass_cnt + error_cnt);
        end
        $display("==================================================");
        
        $finish;
    end

    initial begin
        $dumpfile("add1_04.vcd");
        $dumpvars(0, tb_add1_04);
    end

endmodule