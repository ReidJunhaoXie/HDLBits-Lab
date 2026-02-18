`timescale 1ns / 1ps

module simple_wire_02_tp();
    logic clk ;

    logic tb_in;     // wire or reg --> logic
    logic tb_out;     

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end
    always@(posedge clk) begin
       $display("Time: %0t | Input: %b | Output: %b", $time, tb_in, tb_out) ; 
    end

    simple_wire_02 dut(
        .in(tb_in),
        .out(tb_out)
    );

    initial begin  //iniail block for main test , $display = print
        $display("--------------------------------------------------");
        $display("Starting Testbench: simple_wire");
        $display("--------------------------------------------------");

        drive_and_check(1'b0);  // task --> duplicated function
        drive_and_check(1'b1);
        drive_and_check(1'bx);

        $display("--------------------------------------------------");
        $display("Test Passed: All cases completed successfully!");
        $display("--------------------------------------------------");
        $finish;  // quit simulator
    end

    task drive_and_check(input logic val);   // task --> function
        begin
            tb_in = val;
            repeat(1) @(posedge clk) ;
            #1 ; // delay 10 time unit
            if (tb_out === val) begin   // "===" --> case Euality
                $display("[PASS] Input: %b, Output: %b", tb_in, tb_out);
            end else begin
                $display("[FAIL] Input: %b, Expected: %b, Got: %b", tb_in, val, tb_out);
                $fatal; // Fail and Stop simulation 
            end
        end
    endtask

    // waveform
    initial begin
        $dumpfile("simple_wire.vcd"); // $dumpfile --> Produce Waveform file
        $dumpvars(0, simple_wire_02_tp); // $dumpvars --> signal of simple_wire_02_tp 
    end

endmodule