`timescale 1ns/1ps

module tb_SubAdder07();

    reg  [31:0] a;
    reg  [31:0] b;
    reg         sub;
    wire [31:0] sum;

    logic clk ; 
    logic [31:0] expected_sum;
    integer      error_count;
    integer      test_count;
    integer      i;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    SubAdder07 dut (
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum)
    );

    // Task
    task run_test_case(input [31:0] in_a, input [31:0] in_b, input in_sub, input string test_name);
        begin
            a   = in_a;
            b   = in_b;
            sub = in_sub;
            
            #1; 
            
            // Golden Model
            if (sub == 1'b0) begin
                expected_sum = a + b;
            end else begin
                expected_sum = a - b;
            end
            
            test_count++;
            
            // Self-Checking
            if (sum !== expected_sum) begin
                $display("[FAIL] %s | sub=%b, a=%h, b=%h | DUT sum=%h, Expected=%h", 
                         test_name, sub, a, b, sum, expected_sum);
                error_count++;
            end else begin
                // $display("[PASS] %s", test_name); 
            end
        end
    endtask

    // Test Scenario
    initial begin
        a = 0; b = 0; sub = 0;
        error_count = 0;
        test_count  = 0;
        
        $display("=================================================");
        $display("   Starting SubAdder07 Verification...");
        $display("=================================================");

        //  1: Directed Tests  (Corner Cases) 
        
        run_test_case(32'h0000_FFFF, 32'h0000_0001, 1'b0, "ADD: Carry Propagation to Upper 16-bit");
        run_test_case(32'h0000_7FFF, 32'h0000_8000, 1'b0, "ADD: Max 15-bit sum, no carry");
        run_test_case(32'hFFFF_FFFF, 32'h0000_0001, 1'b0, "ADD: Overflow Case");
        
        run_test_case(32'h0001_0000, 32'h0000_0001, 1'b1, "SUB: Borrow across 16-bit boundary");
        run_test_case(32'h0000_0000, 32'h0000_0001, 1'b1, "SUB: Zero minus One");
        run_test_case(32'hAAAA_5555, 32'hAAAA_5555, 1'b1, "SUB: Same value minus (Zero result)");
        
        // Maximun
        run_test_case(32'h0000_0000, 32'h0000_0000, 1'b0, "ADD: All Zeros");
        run_test_case(32'hFFFF_FFFF, 32'hFFFF_FFFF, 1'b1, "SUB: Max values minus");

        // Random Tests 
        $display("Running Randomized Constrained Tests...");
        for (i = 0; i < 10000; i++) begin
            run_test_case($urandom, $urandom, $urandom_range(0, 1), "Random Test");
        end


        $display("=================================================");
        $display("   Verification Completed!");
        $display("   Total Tests Run : %0d", test_count);
        $display("   Total Errors    : %0d", error_count);
        
        if (error_count == 0) begin
            $display("   STATUS: >>> PASS <<<");
        end else begin
            $display("   STATUS: >>> FAIL <<<");
        end
        $display("=================================================");
        
        $finish;
    end

    initial begin
        $dumpfile("SubAdder07.vcd");
        $dumpvars(0, tb_SubAdder07);
    end

endmodule