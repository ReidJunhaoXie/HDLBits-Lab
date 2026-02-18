`timescale 1ns/1ps

module tb_Vector2_10();

    logic [31:0] tb_in;
    logic [31:0] tb_out;
    logic [31:0] expected_out;

    logic [31:0] rand_val ;
    logic [31:0] exp_val ;

    logic clk ;

    integer i;
    integer error_count = 0;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end
    
    Vector2_swap_10 dut (
        .in (tb_in),
        .out(tb_out)
    );

    initial begin
        $display("=================================================");
        $display("Starting Testbench: Vector2_10 (Byte Swapper)");
        $display("=================================================");

        // Case 1: classic Byte mode
        drive_test(32'h12345678, 32'h78563412);

        // Case 2: Boundary Test
        drive_test(32'h00000000, 32'h00000000);
        drive_test(32'hFFFFFFFF, 32'hFFFFFFFF);

        // Case 3: Randomized Stress Test
        for (i = 0; i < 10; i++) begin
            rand_val = $urandom(); // default 32bits , and static var declaration initialze once
            exp_val = {rand_val[7:0], rand_val[15:8], rand_val[23:16], rand_val[31:24]};
            drive_test(rand_val, exp_val);
        end

        if (error_count == 0) begin
            $display("-------------------------------------------------");
            $display("TEST PASSED! All patterns matched.");
            $display("-------------------------------------------------");
        end else begin
            $display("-------------------------------------------------");
            $display("TEST FAILED! Total Errors: %0d", error_count);
            $display("-------------------------------------------------");
        end
        
        $finish;
    end

    task drive_test(input [31:0] data_in, input [31:0] data_exp);
        begin
            tb_in = data_in;
            expected_out = data_exp;

            repeat(1) @(posedge clk) ;

            if (tb_out !== expected_out) begin
                $display("[ERROR] Input: 0x%h | Expected: 0x%h | Got: 0x%h", 
                          tb_in, expected_out, tb_out);
                error_count = error_count + 1;
            end else begin
                $display("[PASS]  Input: 0x%h | Output: 0x%h", tb_in, tb_out);
            end
        end
    endtask

endmodule