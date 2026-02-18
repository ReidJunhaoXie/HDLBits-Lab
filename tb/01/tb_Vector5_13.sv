`timescale 1ns/1ps
// some tip: Self Checking and Test Scope is need to be import
module tb_Vector5_SignExtension;

    logic [7:0] tb_in;
    logic [31:0] tb_out;

    logic [31:0] expected_out; // Golden Model

    logic clk ;

    integer error_count = 0;
    integer i;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end 

    Vector5_SignExtension DUT (
        .in (tb_in),
        .out(tb_out)
    );

    initial begin
        // initialize 
        tb_in = 0;
        $display("---------------------------------------------------------");
        $display("Starting Exhaustive Verification for Sign Extension Module");
        $display("---------------------------------------------------------");
        
        repeat(1) @(posedge clk);

        // Exhusting Test 
        for (i = 0; i < 256; i = i + 1) begin
            
            tb_in = i[7:0]; 
            
            // $signed
            
            expected_out = $signed(tb_in); 

            #1; 

            // Self checking 
            if (tb_out !== expected_out) begin
                $display("[ERROR] Time=%0t | Input=0x%h | Output=0x%h | Expected=0x%h", 
                         $time, tb_in, tb_out, expected_out);
                
                if (tb_out[31] !== tb_in[7])    // Signed Bit comparation
                    $display("        -> FAILED: Sign bit did not propagate correctly.");
                
                error_count = error_count + 1;
            end
        end

        $display("---------------------------------------------------------");
        if (error_count == 0) begin
            $display("Verification PASSED! All 256 cases matched.");
            $display("  -> Positive numbers checks: OK");
            $display("  -> Negative numbers checks: OK");
        end else begin
            $display("Verification FAILED with %0d errors.", error_count);
        end
        $display("---------------------------------------------------------");
        
        $finish; // 結束模擬
    end

endmodule