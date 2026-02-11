`timescale 1ns/1ps

module tb_declare_wire06();

    logic a, b, c, d;
    logic out, out_n;

    logic expected_out;
    integer i;
    logic clk ;

    initial begin
        clk = 0 ;     // clk 一定要初始化
        forever #5 clk = ~clk ; 
    end

    declare_wire06 u_dut (
        .a     (a),
        .b     (b),
        .c     (c),
        .d     (d),
        .out   (out),
        .out_n (out_n)
    );


    initial begin
        $dumpfile("declare_wire06.vcd");
        $dumpvars(0, tb_declare_wire06);

        for (i = 0; i < 16; i = i + 1) begin
            
            {a, b, c, d} = i[3:0];
            #1 ; // 這個 delay 一定要，給 dut 時間更新
            expected_out = (a & b) | (c & d);
            $display("Time=%0t | a=%b b=%b c=%b d=%b | out=%b | expected=%b", 
            $time, a, b, c, d, out, expected_out);
            repeat(1) @(posedge clk) ;
            
            if (out !== expected_out) begin
                $display("ERROR at time %0t: Input %b%b%b%b, Expected %b, Got %b", 
                         $time, a, b, c, d, expected_out, out); 
                         $fatal(1,"Logic Misnatch") ;
            end
            
            if (out_n === out) begin
                $display("ERROR at time %0t: out_n (%b) is NOT inverted from out (%b)", 
                         $time, out_n, out);
                         $fatal(1,"Inverter Mismatch") ;
            end
        end

        #10;
        $display("-------------------------------------------");
        $display(" Simulation Completed. Please check waves. ");
        $display("-------------------------------------------");
        $finish;
    end

endmodule