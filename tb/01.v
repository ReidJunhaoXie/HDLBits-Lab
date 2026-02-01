`timescale 1ns/1ps  // 設定時間單位：每1奈秒為一單位 / 精確度1皮秒

module top_tb;

    // 1. 宣告訊號
    // 因為 out 是從 DUT (Device Under Test) 輸出的，這裡我們要用 wire 接它
    wire t_out;

    // 2. 例化設計 (Instantiate the DUT)
    // 格式：模組名 實例名 ( .埠口名(連接的訊號名) );
    wire_01 dut(
        .out(t_out)
    );

    // 3. 模擬流程控制 (Initial Block)
    initial begin
        // --- 設定波形輸出 ---
        // 配合你的手打指令，我們把波形存在 sim/ 資料夾
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, top_tb); // 0 代表紀錄 top_tb 下面所有層級的訊號

        // --- 顯示監控訊息 ---
        // $monitor 只要訊號有變動，就會印出這行
        $monitor("Time: %0t | Output = %b", $time, t_out);

        // --- 執行模擬 ---
        $display(">>> Simulation Start");
        
        #10;  // 等待 10 個時間單位 (10ns)
        
        // 簡單的自我檢查
        if (t_out === 1'b1) 
            $display(">>> Check: PASS (Output is 1)");
        else
            $display(">>> Check: FAIL (Output is %b)", t_out);

        $display(">>> Simulation End");
        $finish; // 結束模擬
    end

endmodule