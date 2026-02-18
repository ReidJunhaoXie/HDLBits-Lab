`timescale 1ns/1ps

module tb_Vector6_Advance_duplicate_14;

    logic a, b, c, d, e;
    logic [24:0] out;

    logic [4:0] stimulus_vector;

    logic [24:0] expected_out;
    logic [24:0] expected_comb_A;
    logic [24:0] expected_comb_B;

    logic clk ;

    int error_count = 0;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    Vector_Advance_duplicate dut (
        .a(a), .b(b), .c(c), .d(d), .e(e),
        .out(out)
    );

    initial begin
        // 初始化
        $display("---------------------------------------------------------");
        $display("Starting Exhaustive Verification for Vector_Advance_duplicate");
        $display("---------------------------------------------------------");
        
        // Exhaust test
        for (int i = 0; i < 32; i++) begin
            stimulus_vector = i;
            
            {a, b, c, d, e} = stimulus_vector;

            repeat(1) @(posedge clk) ;

            check_output();
        end

        $display("---------------------------------------------------------");
        if (error_count == 0)
            $display("TEST PASSED: All 32 vectors matched successfully!");
        else
            $display("TEST FAILED: Found %0d mismatches.", error_count);
        $display("---------------------------------------------------------");
        
        $finish;
    end

    // Golden Model 、 Scoreboard 
    task check_output;
        //Golden Model)
        // logic: {5{a,b,c,d,e}} -> abcde_abcde_abcde_abcde_abcde
        expected_comb_A = {5{a, b, c, d, e}};
        
        // logic: {{5{a}},...} -> aaaaa_bbbbb_ccccc_ddddd_eeeee
        expected_comb_B = {{5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}}};
        
        // logic: ~A ^ B 
        expected_out = ~expected_comb_A ^ expected_comb_B;

        // Check
        if (out !== expected_out) begin
            $error("ERROR at time %0t: Input(abcde)=%b", $time, stimulus_vector);
            $display("  Expected: %b (Hex: %h)", expected_out, expected_out);
            $display("  Actual:   %b (Hex: %h)", out, out);
            $display("  Debug info: A_pat=%b, B_pat=%b", expected_comb_A, expected_comb_B);
            error_count++;
        end
    endtask

endmodule