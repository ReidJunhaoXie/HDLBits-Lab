`timescale 1ns/1ps

module tb_ModuleShift02;

    reg clk;
    reg d;
    wire q;

    parameter CLK_PERIOD = 10; // 100MHz
    parameter TEST_CYCLES = 50;

    // Golden Model 
    reg [2:0] expected_shift_reg; 

    integer cycle_count;
    integer error_count;

    ModuleShift02 u_dut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    //  Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        //  Initialization 
        d = 0;
        expected_shift_reg = 3'b000; // 假設初始狀態為 0
        error_count = 0;
        cycle_count = 0;

        #(CLK_PERIOD * 2);

        $display("---------------------------------------------------");
        $display("START SIMULATION: 3-Stage Shift Register Verification");
        $display("---------------------------------------------------");

        // Test Loop 
        repeat (TEST_CYCLES) begin
            // Test setup time stability by negedge clk 
            @(negedge clk);
            
            // random gen 0 or 1
            d = $random % 2;
            // when negedge we drive data, when posedge we sample data
        end

        // Pipeline flush
        repeat (5) @(negedge clk) d = 0;

        $display("---------------------------------------------------");
        if (error_count == 0)
            $display("TEST PASSED: No errors found.");
        else
            $display("TEST FAILED: Found %d errors.", error_count);
        $display("---------------------------------------------------");
        $finish;
    end

    //  Scoreboard
    always @(posedge clk) begin
        expected_shift_reg <= {expected_shift_reg[1:0], d};
    end

    // 因為 DFF 有延遲，當下 Clock edge sample到的 q，
    // 應該等於 "上一個 Clock edge" 時 stored 在最後一級 DFF 的值。
    // 當下的 q 應該等於 expected_shift_reg[2] (尚未更新前的值)
    
    // 在 Clock posedge 後一點點時間比對
    always @(posedge clk) begin
        #(1); // Hold time margin
        
        // Because submodule DFF dont have Reset, So ignore first 3 cycle time   
        if (cycle_count > 3) begin
            if (q !== expected_shift_reg[2]) begin
                $display("[ERROR] Time=%t | Input d=%b | Expected q=%b | Actual q=%b", 
                         $time, d, expected_shift_reg[2], q);
                error_count = error_count + 1;
            end else begin
                // success 
                // $display("[OK] Time=%t | q=%b", $time, q);
            end
        end
        cycle_count = cycle_count + 1;
    end

    //  Dump Waveform (For Debugging)
    initial begin
        $dumpfile("shift_reg.vcd");
        $dumpvars(0, tb_ModuleShift02);
    end

endmodule