`timescale 1ns/1ps

module tb_7458_chip_07();

    logic p1a, p1b, p1c, p1d, p1e, p1f;
    logic p2a, p2b, p2c, p2d;
    wire  p1y, p2y; // DUT 輸出建議用 wire

    logic exp_p1y, exp_p2y;
    int   error_count = 0;
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task exp_gen; 
        begin
            exp_p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f); 
            exp_p2y = (p2a & p2b) | (p2c & p2d);
        end
    endtask

    rtl_7458_chip_07 uut (
        .p1a(p1a), .p1b(p1b), .p1c(p1c), .p1d(p1d), .p1e(p1e), .p1f(p1f),
        .p1y(p1y),
        .p2a(p2a), .p2b(p2b), .p2c(p2c), .p2d(p2d),
        .p2y(p2y)
    );

    initial begin
        $display("=======================================");
        $display("Starting Simulation: 7458_chip_07");
        $display("=======================================");
        
        // 初始化
        {p1a, p1b, p1c, p1d, p1e, p1f} = 6'b0;
        {p2a, p2b, p2c, p2d} = 4'b0;
        
        // 等待 Reset/系統穩定
        repeat(2) @(posedge clk); 

        // [P2 測試]: 窮舉測試 (Exhaustive Test)
        $display("Testing P2 Logic (AND-OR)...");
        for (int i = 0; i < 16; i++) begin
            @(posedge clk);
            {p2a, p2b, p2c, p2d} = i[3:0];

            exp_gen();

            @(negedge clk);
            check_results("P2_Loop");
        end

        // ------------------------------------------------
        // [P1 測試]: 定向測試 (Directed Test)
        // ------------------------------------------------
        $display("Testing P1 Logic (Triple-AND-OR)...");

        test_p1(6'b111_000); 
        test_p1(6'b000_111); 
        test_p1(6'b110_011); 
        test_p1(6'b111_111); 

        // ------------------------------------------------
        // ------------------------------------------------
        if (error_count == 0)
            $display("\nSUCCESS: All tests passed!\n");
        else
            $display("\nFAILURE: %0d errors found during simulation.\n", error_count);
            
        $finish;
    end

    task test_p1(input [5:0] pattern);
        begin
            @(posedge clk);                 // Drive
            {p1a, p1b, p1c, p1d, p1e, p1f} = pattern;
            
            exp_gen();                      // Model Calc (關鍵！自動更新 exp_p1y)
            
            @(negedge clk);                 // Sample
            check_results("P1_Task");
        end
    endtask

    //  Direct Access 
    task check_results(input string msg);
        begin
            if (p1y !== exp_p1y || p2y !== exp_p2y) begin
                $display("ERROR at %t [%s]:", $time, msg);
                $display("  Inputs: P1=%b, P2=%b", {p1a,p1b,p1c,p1d,p1e,p1f}, {p2a,p2b,p2c,p2d});
                $display("  Exp/Got P1: %b / %b", exp_p1y, p1y);
                $display("  Exp/Got P2: %b / %b", exp_p2y, p2y);
                error_count++;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_7458.vcd");
        $dumpvars(0, tb_7458_chip_07);
    end

endmodule