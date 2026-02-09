`timescale 1ns/1ps

module tb_xnor_05();

    logic a;
    logic b;
    wire  out;
    logic clk ; 
    logic expected_out;
    
    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;    
    end
    xnor_05 uut (
        .a   (a),
        .b   (b),
        .out (out)
    );

    initial begin
        $dumpfile("tb_xnor_05.vcd");
        $dumpvars(0, tb_xnor_05);
        $display("Starting XNOR Testbench...");
        $display("A B | Out | Expected | Status");
        $display("---------------------------------------");

        drive_test(1'b0, 1'b0);
        drive_test(1'b0, 1'b1);
        drive_test(1'b1, 1'b0);
        drive_test(1'b1, 1'b1);

        $display("---------------------------------------");
        $display("Testbench Completed Successfully!");
        $finish;
    end

    task drive_test(input logic val_a, input logic val_b);
        begin
            a = val_a;
            b = val_b;
            
            expected_out = (val_a ~^ val_b);
            
            repeat(1) @(posedge clk) ; 
            if (out !== expected_out) begin
                $display("%b %b |  %b  |     %b    | [FAILED]", a, b, out, expected_out);
                $fatal(1,"Mismatch detected! Verification stopped.");
            end else begin
                $display("%b %b |  %b  |     %b    | [PASSED]", a, b, out, expected_out);
            end
        end
    endtask

endmodule