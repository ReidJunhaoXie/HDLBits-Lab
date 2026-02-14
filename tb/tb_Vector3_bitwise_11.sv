`timescale 1ns/1ps

module tb_Vector3_bitwise_11;

    logic [2:0] a;
    logic [2:0] b;
    logic [2:0] out_or_bitwise;
    logic       out_or_logical;
    logic [5:0] out_not;

    logic [2:0] exp_or_bitwise;
    logic       exp_or_logical;
    logic [5:0] exp_not;

    logic clk ;

    integer error_count = 0;
    integer test_count = 0;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    Vector3_bitwise_11 u_dut (
        .a              (a),
        .b              (b),
        .out_or_bitwise (out_or_bitwise),
        .out_or_logical (out_or_logical),
        .out_not        (out_not)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_Vector3_bitwise_11);

        $display("==================================================");
        $display("   STARTING TESTBENCH for Vector3_bitwise_11      ");
        $display("==================================================");

        // Exhaustive Testing
        
        for (int i = 0; i < 8; i++) begin       
            for (int j = 0; j < 8; j++) begin   
                
                a = i[2:0];
                b = j[2:0];
                
                repeat(1) @(posedge clk) ; 

                exp_or_bitwise = a | b;
                exp_or_logical = (a || b); 
                exp_not        = {~b, ~a};

                // Self-Checking
                check_outputs();
            end
        end

        $display("==================================================");
        if (error_count == 0) begin
            $display("   TEST PASSED! All %0d vectors verified.", test_count);
            $display("   Congratulation! Your design is robust.");
        end else begin
            $display("   TEST FAILED. Total Errors: %0d", error_count);
        end
        $display("==================================================");
        
        $finish;
    end

    // Check Task
    task check_outputs;
        test_count++;
        if (out_or_bitwise !== exp_or_bitwise || 
            out_or_logical !== exp_or_logical || 
            out_not        !== exp_not) begin
            
            error_count++;
            $display("[ERROR] Time=%0t | Inputs: a=%b, b=%b", $time, a, b);
            
            if (out_or_bitwise !== exp_or_bitwise) 
                $display("    -> Bitwise OR Mismatch: DUT=%b, EXP=%b", out_or_bitwise, exp_or_bitwise);
            
            if (out_or_logical !== exp_or_logical) 
                $display("    -> Logical OR Mismatch: DUT=%b, EXP=%b", out_or_logical, exp_or_logical);
            
            if (out_not !== exp_not) 
                $display("    -> NOT/Concat Mismatch: DUT=%b, EXP=%b", out_not, exp_not);
        end
    endtask

endmodule