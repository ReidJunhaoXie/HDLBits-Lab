`timescale 1ns / 1ps

module tb_n_wire_03();

    logic a, b, c;           // Inputs
    logic w, x, y, z;        // Outputs
    
    logic [3:0] expected_val;   // 正確答案
    logic [3:0] actual_val;     // 實際答案

    n_wire_03 u_dut (
        .a(a), .b(b), .c(c),
        .w(w), .x(x), .y(y), .z(z)
    );                      // intantiate module

    assign actual_val = {w, x, y, z};

    initial begin    // test in initial block
        $display("\n[Verification Start] Target: n_wire_03");
        $display("--------------------------------------------");
        $display(" TIME | A B C | W X Y Z | Status"); // 時間 | input | output | outcome
        $display("--------------------------------------------");

        // 瓊舉所有輸入組合 (2^3 = 8)
        for (int i = 0; i < 8; i++) begin // 宣告 32bit array i
            {a, b, c} = i[2:0];
            #1; // delay 1 time unit 
            
            // 準備正確答案 
            expected_val = {a, b, b, c};

            // 自動比對
            if (actual_val === expected_val) begin
                $display("%5tps | %b %b %b | %b %b %b %b | PASS",  // %5t -> time | ps -> pico second
                         $time, a, b, c, w, x, y, z);
            end else begin
                $display("%5tps | %b %b %b | %b %b %b %b | FAIL (Exp: %b)", 
                         $time, a, b, c, w, x, y, z, expected_val);
            end
        end
        $display("--------------------------------------------");
        $display("[Verification Finished] All vectors checked.\n");
        $finish;
    end // all of the $ need to be in initial block

    initial begin
        $dumpfile("n_wire_03_sim.vcd");
        $dumpvars(0, tb_n_wire_03);
    end

endmodule