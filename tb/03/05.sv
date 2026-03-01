`timescale 1ns/1ps

module tb_Case05();

    reg  [2:0] sel;
    reg  [3:0] data0, data1, data2, data3, data4, data5;
    wire [3:0] out;

    integer total_tests;
    integer error_count;

    Case05 u_dut (
        .sel   (sel),
        .data0 (data0),
        .data1 (data1),
        .data2 (data2),
        .data3 (data3),
        .data4 (data4),
        .data5 (data5),
        .out   (out)
    );

    task drive_and_check;
        input [2:0] in_sel;    
        reg   [3:0] exp_out;   
        begin
            // Drive Stimulus
            sel = in_sel;
            
            data0 = $urandom_range(15); 
            data1 = $urandom_range(15); 
            data2 = $urandom_range(15);
            data3 = $urandom_range(15); 
            data4 = $urandom_range(15); 
            data5 = $urandom_range(15);
            // Wait for settling
            #5; 

            // Golden Reference Model
            case(sel)
                3'd0: exp_out = data0;
                3'd1: exp_out = data1;
                3'd2: exp_out = data2;
                3'd3: exp_out = data3;
                3'd4: exp_out = data4;
                3'd5: exp_out = data5;
                default: exp_out = 4'd0;
            endcase

            // Self-Checking
            total_tests = total_tests + 1;
            if (out !== exp_out) begin
                $display("[ERROR] Time: %0t | sel: %b | Expected: %h, Got: %h", 
                         $time, sel, exp_out, out);
                error_count = error_count + 1;
            end else begin
                $display("[PASS] Time: %0t | sel: %b | out: %h", $time, sel, out);
            end
            
            // memory flush
            #5; 
        end
    endtask

    // Main Test Flow
    integer i;

    initial begin
        $dumpfile("Case05_tb.vcd");
        $dumpvars(0, tb_Case05);

        total_tests = 0;
        error_count = 0;
        sel = 3'd0;
        data0 = 0; data1 = 0; data2 = 0; data3 = 0; data4 = 0; data5 = 0;
        
        $display("=================================================");
        $display("initialize.. ");
        $display("=================================================");
        #10; 

        // ---------------------------------------------------------------------
        $display("\n[Phase 1] legal Selector (0 ~ 5)...");
        // ---------------------------------------------------------------------
        for (i = 0; i < 6; i = i + 1) begin
            drive_and_check(i);
        end

        // ---------------------------------------------------------------------
        $display("\n[Phase 2] illegal Selector (6 ~ 7) ...");
        // ---------------------------------------------------------------------
        for (i = 6; i < 8; i = i + 1) begin
            drive_and_check(i);
        end

        // ---------------------------------------------------------------------
        $display("\n[Phase 3] X/Z  Default ...");
        // ---------------------------------------------------------------------
        drive_and_check(3'bx);
        drive_and_check(3'bz);

        // ---------------------------------------------------------------------
        // Summary Report
        // ---------------------------------------------------------------------
        $display("\n=================================================");
        $display("Test Summary:");
        $display("test number : %0d", total_tests);
        $display("error number : %0d", error_count);
        $display("=================================================");
        
        if (error_count == 0) begin
            $display("[RESULT] ALL TESTS PASSED! \n");
        end else begin
            $display("[RESULT] SOME TESTS FAILED! \n");
        end
        
        #10;
        $finish;
    end

endmodule