// tips : 1. self-checking 2. Directed test(corner) 3. random test
`timescale 1ns/1ps

module tb_CarrySelectAdder06;

    logic  [31:0] a;
    logic [31:0] b;
    logic [31:0] sum;

    logic clk ;

    integer error_count;
    integer test_count;
    reg [31:0] expected_sum;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end
    
    CarrySelectAdder06 dut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    task drive_and_check; // drive -->  data ; check   tips : task is a procedure block
        input [31:0] val_a; // 
        input [31:0] val_b;
        begin
            a = val_a;
            b = val_b;
            
            repeat(2) @(posedge clk) ;
            
            expected_sum = val_a + val_b;
            
            test_count = test_count + 1;
            
            if (sum !== expected_sum) begin
                $display("[ERROR] Time: %0t | A: %h, B: %h | Expected: %h, Got: %h", 
                         $time, a, b, expected_sum, sum);
                error_count = error_count + 1;
            end
        end
    endtask 

    //Main Test Sequence
    initial begin
        $dumpfile("CarrySelectAdder06.vcd");
        $dumpvars(0, tb_CarrySelectAdder06);
        
        a = 32'b0;
        b = 32'b0;
        error_count = 0;
        test_count = 0;
        
        $display("==================================================");
        $display("   [START] CarrySelectAdder06 Verification        ");
        $display("==================================================");

        // Phase 1: Directed Tests 
        $display("[INFO] Running Phase 1: Directed Tests...");
        
        // 1. All Zeros
        drive_and_check(32'h0000_0000, 32'h0000_0000);
        
        // 2. All Ones 
        drive_and_check(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        
        // 3. Alternating patterns 
        drive_and_check(32'h5555_5555, 32'hAAAA_AAAA);
        
        // 4. Critical Path 
        // most important
        drive_and_check(32'h0000_FFFF, 32'h0000_0001); //  lower half cout = 1
        drive_and_check(32'h0000_FFFE, 32'h0000_0001); //  lower half cout = 0
        
        // 5. Upper half carry propagation (worst/critical path)
        drive_and_check(32'hFFFF_FFFF, 32'h0000_0001);

        // Phase 2: Pseudo-Random Tests 
        $display("[INFO] Running Phase 2: 10,000 Random Tests...");
        begin : random_test_block // begin-end Name block  -- integer
            integer i;
            for (i = 0; i < 10000; i = i + 1) begin
                drive_and_check($urandom, $urandom);
            end
        end

        // Report Summary
        $display("==================================================");
        $display("   [FINISH] Verification Summary                  ");
        $display("   Total Tests Run : %0d", test_count);
        $display("   Total Errors    : %0d", error_count);
        if (error_count == 0) begin
            $display("   Result: >>> PASS <<<");
        end else begin
            $display("   Result: >>> FAIL <<<");
        end
        $display("==================================================");

        #10 $finish;
    end

endmodule