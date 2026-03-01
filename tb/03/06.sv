`timescale 1ns/1ps

module tb_PriorityCase;

    logic [3:0] in;
    logic [1:0] pos;
    
    logic [1:0] expected_pos; 
    int         error_count;

    PriorityCase u_dut (
        .in  (in),
        .pos (pos)
    );
    function logic [1:0] get_expected_pos(input logic [3:0] val); // function --> pure comnibational ; function return function_name(input..)
        if      (val[0] == 1'b1) return 2'd0;
        else if (val[1] == 1'b1) return 2'd1;
        else if (val[2] == 1'b1) return 2'd2;
        else if (val[3] == 1'b1) return 2'd3;
        else                     return 2'd0;
    endfunction

    // Stimulus Generation & Self-Checking
    initial begin
        // Initialize
        error_count = 0;
        in = 4'b0000;
        $display("=================================================");
        $display("start ");
        $display("=================================================");

        $dumpfile("tb_PriorityCase.vcd");
        $dumpvars(0, tb_PriorityCase);

        // Exhust test
        for (int i = 0; i < 16; i++) begin
            in = i[3:0];
            
            #10; 
            
            expected_pos = get_expected_pos(in); // Golden Model

            // Assertion / Checking
            if (pos !== expected_pos) begin
                $error("[FAIL] Time=%0t | in=%b | Expected pos=%0d, but got pos=%0d", 
                       $time, in, expected_pos, pos);
                error_count++;
            end else begin
                $display("[PASS] Time=%0t | in=%b | pos=%0d", $time, in, pos);
            end
        end
        // Summary
        $display("=================================================");
        if (error_count == 0) begin
            $display("[SUCCESS] ");
        end else begin
            $display("[FAILED]  %0d error", error_count);
        end
        $display("=================================================");

        $finish;
    end

endmodule