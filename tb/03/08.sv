`timescale 1ns/1ps

module tb_DefaultValue08;

    logic [15:0] scancode;
    logic        left;
    logic        down;
    logic        right;
    logic        up;

    int error_count = 0; 
    int test_count = 0;  

    DefaultValue08 u_dut (
        .scancode (scancode),
        .left     (left),
        .down     (down),
        .right    (right),
        .up       (up)
    );

    task check_scancode(
        input [15:0] in_code,
        input        exp_left,
        input        exp_down,
        input        exp_right,
        input        exp_up
    );
        begin
            test_count++;
            scancode = in_code; // drive dut
            
            #5; 

            // Check 
            if (left !== exp_left || down !== exp_down || right !== exp_right || up !== exp_up) begin
                $display("[ERROR] Time: %0t | Scancode: 16'h%0h | Expected: L=%b, D=%b, R=%b, U=%b | Actual: L=%b, D=%b, R=%b, U=%b",
                         $time, in_code, exp_left, exp_down, exp_right, exp_up, left, down, right, up);
                error_count++;
            end else begin
                $display("[PASS] Time: %0t | Scancode: 16'h%0h verified.", $time, in_code);
            end
            
            #5; 
        end
    endtask

    // Test 
    initial begin
        $display("==================================================");
        $display("  Start Testing: DefaultValue08 (Scancode Decoder)");
        $display("==================================================");

        // initialize
        scancode = 16'h0000;
        #10;

        // Valid Scancodes
        check_scancode(16'he06b, 1'b1, 1'b0, 1'b0, 1'b0); // Left
        check_scancode(16'he072, 1'b0, 1'b1, 1'b0, 1'b0); // Down
        check_scancode(16'he074, 1'b0, 1'b0, 1'b1, 1'b0); // Right
        check_scancode(16'he075, 1'b0, 1'b0, 1'b0, 1'b1); // Up

        // Invalid/Default Scancodes
        check_scancode(16'h0000, 1'b0, 1'b0, 1'b0, 1'b0); // All Zero edge case
        check_scancode(16'hffff, 1'b0, 1'b0, 1'b0, 1'b0); // All One edge case
        check_scancode(16'he06a, 1'b0, 1'b0, 1'b0, 1'b0); // Off-by-one error check (e06b - 1)
        check_scancode(16'he076, 1'b0, 1'b0, 1'b0, 1'b0); // Off-by-one error check (e075 + 1)
        
        // Random Stimulus
        repeat (5) begin
            logic [15:0] rand_code;
            rand_code = $urandom();
            //  default，expected almost 0
            check_scancode(rand_code, 1'b0, 1'b0, 1'b0, 1'b0);
        end

        // Test Summary
        $display("==================================================");
        if (error_count == 0) begin
            $display("  [SUCCESS] All %0d tests passed without errors!", test_count);
        end else begin
            $display("  [FAILED] %0d out of %0d tests failed. Check logs.", error_count, test_count);
        end
        $display("==================================================");
        
        $finish;
    end

    // Dump Waveform
    initial begin
        $dumpfile("tb_DefaultValue08.vcd");
        $dumpvars(0, tb_DefaultValue08);
    end

endmodule