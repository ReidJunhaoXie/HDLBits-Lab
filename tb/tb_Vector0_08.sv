`timescale 1ns/1ps

module tb_Vector0_08;

    logic [2:0] vec;
    logic [2:0] outv;
    logic       o2, o1, o0;

    logic clk ;
    
    int error_count = 0;
    int test_count  = 0;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    Vector0_08 dut (
        .vec (vec),
        .outv(outv),
        .o2  (o2),
        .o1  (o1),
        .o0  (o0)
    );

    initial begin
        // initialize
        vec = 0;
        
        $display("\n========================================================");
        $display("   STARTING TESTBENCH FOR Vector0_08   ");
        $display("========================================================\n");

        for (int i = 0; i < 8; i++) begin
            drive_input(i);      // 驅動輸入
            check_output(i);     // 自動檢查輸出
        end

        $display("\n========================================================");
        if (error_count == 0) begin
            $display("   TEST PASSED! All %0d cases verified successfully.", test_count);
        end else begin
            $display("   TEST FAILED! Found %0d errors in %0d cases.", error_count, test_count);
        end
        $display("========================================================\n");
        
        $finish; // 結束模擬
    end

    task drive_input(input int val);
        vec = val[2:0];
        repeat(2) @(posedge clk) ;
    endtask

    task check_output(input int expected_val);
        logic [2:0] exp_vec;
        logic       exp_o2, exp_o1, exp_o0;
        
        exp_vec = expected_val[2:0];
        exp_o2  = expected_val[2];
        exp_o1  = expected_val[1];
        exp_o0  = expected_val[0];

        test_count++;

        if (outv !== exp_vec) begin
            $error("[Time %0t] Error: Vector Mismatch! Input=%b, Expected outv=%b, Got=%b", 
                    $time, vec, exp_vec, outv);
            error_count++;
        end

        if ({o2, o1, o0} !== exp_vec) begin
            $error("[Time %0t] Error: Bit Split Mismatch! Input=%b, Expected {o2,o1,o0}=%b, Got={%b,%b,%b}", 
                    $time, vec, exp_vec, o2, o1, o0);
            error_count++;
        end
    endtask

endmodule