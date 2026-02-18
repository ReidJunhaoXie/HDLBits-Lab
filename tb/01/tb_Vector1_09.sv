`timescale 1ns/1ps

module tb_Vector1_09();

    logic [15:0] in;
    wire  [7:0]  out_hi;
    wire  [7:0]  out_lo;

    logic [7:0]  exp_hi;
    logic [7:0]  exp_lo;

    logic clk ; 
    
    integer i;
    integer error_count = 0;

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end 

    Vector1_09 dut (
        .in     (in),
        .out_hi (out_hi),
        .out_lo (out_lo)
    );

    initial begin
        $display("=================================================");
        $display("Starting Testbench: Vector1_09");
        $display("=================================================");

        for (i = 0; i < 20; i = i + 1) begin

            in = $urandom_range(0, 16'hFFFF);  //  產生unsigned隨機數(0-65535) 
            
            // Golden Model
            exp_hi = in[15:8];
            exp_lo = in[7:0];

            repeat(1) @(posedge clk) ;
            
            if ((out_hi !== exp_hi) || (out_lo !== exp_lo)) begin
                $display("[ERROR] Time:%0t | IN:%h | EXP_HI:%h GOT:%h | EXP_LO:%h GOT:%h", 
                          $time, in, exp_hi, out_hi, exp_lo, out_lo);
                error_count = error_count + 1;
            end else begin
                $display("[PASS]  Time:%0t | IN:%h -> HI:%h, LO:%h", 
                          $time, in, out_hi, out_lo);
            end
        end

        $display("=================================================");
        if (error_count == 0) begin
            $display("TEST PASSED SUCCESSFULLY!");
        end else begin
            $display("TEST FAILED! Total Errors: %0d", error_count);
        end
        $display("=================================================");
        $finish;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_Vector1_09);
    end

endmodule