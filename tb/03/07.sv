`timescale 1ns/1ps

module tb_Casez07;

    logic [7:0] in;
    logic [2:0] pos;
    
    int error_count = 0;

    Casez07 dut (
        .in(in),
        .pos(pos)
    );
    // get golden model
    function automatic logic [2:0] get_expected_pos(logic [7:0] val);  // automatic allocate memory
        if      (val[0]) return 3'd0;
        else if (val[1]) return 3'd1;
        else if (val[2]) return 3'd2;
        else if (val[3]) return 3'd3;
        else if (val[4]) return 3'd4;
        else if (val[5]) return 3'd5;
        else if (val[6]) return 3'd6;
        else if (val[7]) return 3'd7;
        else             return 3'd0; 
    endfunction

    // Checker Task
    task check_result(input string test_name);
        #1; 
        if (pos !== get_expected_pos(in)) begin
            $error("[FAIL] %s: in=8'b%08b, expected=%0d, got=%0d", 
                    test_name, in, get_expected_pos(in), pos);
            error_count++;
        end else begin
            $display("[PASS] %s: in=8'b%08b => pos=%0d", test_name, in, pos);
        end
    endtask

    // Main
    initial begin
        $display("=======================================");
        $display("  Priority Encoder Verification Start  ");
        $display("=======================================");

        // 1. zero
        in = 8'b0000_0000; check_result("All Zeros");

        // 2. Walking Ones
        for (int i = 0; i < 8; i++) begin
            in = 8'b1 << i; // << left shift
            check_result($sformatf("Walking One bit[%0d]", i));
        end

        // 3. Priority Check
        in = 8'b1111_1111; check_result("All Ones (LSB Priority)");
        in = 8'b1000_0001; check_result("MSB and LSB High");
        in = 8'b0110_0100; check_result("Multiple Bits [6,5,2]");

        // 4. Randomized Stimulus
        $display("--- Starting Random Tests ---");
        for (int i = 0; i < 20; i++) begin
            in = $urandom_range(0, 255);
            check_result($sformatf("Random Test %0d", i));
        end

        $display("=======================================");
        if (error_count == 0)
            $display("  [SUCCESS] All tests passed!          ");
        else
            $display("  [FAILED] Total errors: %0d           ", error_count);
        $display("=======================================");
        
        $finish;
    end
        initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_Casez07);
        end
endmodule