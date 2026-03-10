`timescale 1ns/1ps

module tb_ConditionTenary;

    parameter DATA_WIDTH = 8;
    parameter NUM_RANDOM_TESTS = 1000;

    reg  [DATA_WIDTH-1:0] a, b, c, d;
    wire [DATA_WIDTH-1:0] min;

    reg  [DATA_WIDTH-1:0] expected_min; 
    integer pass_count;
    integer fail_count;
    integer i;
    
    ConditionTenary uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .min(min)
    );

    task check_min;
        input [DATA_WIDTH-1:0] in_a, in_b, in_c, in_d;
        begin
            a = in_a; b = in_b; c = in_c; d = in_d;
            
            #10; 

            // Golden Model
            expected_min = in_a;
            if (in_b < expected_min) expected_min = in_b;
            if (in_c < expected_min) expected_min = in_c;
            if (in_d < expected_min) expected_min = in_d;

            // Self-Checking
            if (min === expected_min) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
                $display("[ERROR] Time: %0t | a=%3d, b=%3d, c=%3d, d=%3d | Exp: %3d, DUT: %3d",
                         $time, a, b, c, d, expected_min, min);
            end
        end
    endtask

    initial begin
      
        a = 0; b = 0; c = 0; d = 0;
        pass_count = 0;
        fail_count = 0;

        $display("==================================================");
        $display("ConditionTenary");
        $display("==================================================");

        // Directed Tests / Corner Cases
        $display("--> Directed Tests ");
        check_min(8'h00, 8'h00, 8'h00, 8'h00); // 0
        check_min(8'hFF, 8'hFF, 8'hFF, 8'hFF); // 1 
        
        // Differant test
        check_min(8'h05, 8'hFF, 8'hFF, 8'hFF); // Min at a
        check_min(8'hFF, 8'h05, 8'hFF, 8'hFF); // Min at b
        check_min(8'hFF, 8'hFF, 8'h05, 8'hFF); // Min at c
        check_min(8'hFF, 8'hFF, 8'hFF, 8'h05); // Min at d
        
        // boundar
        check_min(8'h80, 8'h7F, 8'h80, 8'h7F); 
        check_min(8'hAA, 8'h55, 8'hAA, 8'h55); // Checkerboard 0101 / 1010

        // Randomized Tests
        $display("--> %0d  Randomized Tests...", NUM_RANDOM_TESTS);
        for (i = 0; i < NUM_RANDOM_TESTS; i = i + 1) begin
            check_min($urandom_range(255,0), $urandom_range(255,0), $urandom_range(255,0),$urandom_range(255,0));
        end

        // Test Summary
        // ==========================================
        $display("==================================================");
        $display("Verification Complete");
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("STATUS:  SUCCESS ");
        end else begin
            $display("STATUS: FAILED");
        end
        $display("==================================================");

        $finish; 
    end

endmodule