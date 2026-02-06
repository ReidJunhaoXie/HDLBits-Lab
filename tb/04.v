`timescale 1ns / 1ps 

module tb_not_gate_04();

    logic tb_in ;
    logic tb_out ;

    logic expected_out ;  // 正確結果

    integer test_count = 0 ;
    integer error_count = 0 ; // 整數 count

    tb_not_gate_04 dut(.in(tb_in), .out(tb_out)) ;

    initial begin
        $display("---------------------------------------");
        $display("Starting Testbench: not_gate_04");
        $display("---------------------------------------");
        
        apply_test(1'b0);
        apply_test(1'b1);

        $display("---------------------------------------");
        if (error_count == 0) begin
            $display("TEST PASSED (%0d cases)", test_count);  // %0d --> 0 壓縮空格
        end else begin
            $display("TEST FAILED: %0d errors found", error_count);
        end
        $display("---------------------------------------");
        $finish;
    end

    task apply_test(input i_val);
        begin
            tb_in = i_val;
            expected_out = ~i_val; // Golden model 
            #10; // delay 10 time unit 
            
            test_count = test_count + 1;
            
            if (tb_out !== expected_out) begin
                $display("[ERROR] Input: %b | Expected: %b | Got: %b at %0t ps", 
                          tb_in, expected_out, tb_out, $time);
                error_count = error_count + 1;
            end else begin
                $display("[INFO]  Input: %b | Output: %b (Correct)", tb_in, tb_out);
            end
        end
    endtask

    initial begin
        $dumpfile("sim/not_gate_tb.vcd");
        $dumpvars(0, tb_not_gate_04);
    end

endmodule

