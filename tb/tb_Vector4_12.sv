`timescale 1ns/1ps

module tb_Vector4_12;

    logic [4:0] a, b, c, d, e, f;
    wire [7:0] w, x, y, z;

    logic clk ;

    integer i;
    integer error_count = 0;

    Vector4_partselection_12 DUT (
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f),
        .w(w), .x(x), .y(y), .z(z)
    );

    initial begin
        clk = 0 ;
        forever #5 clk = ~clk ;
    end

    initial begin
        // 初始化
        a = 0; b = 0; c = 0; d = 0; e = 0; f = 0;
        $display("---------------------------------------------------------------");
        $display("START TESTBENCH: Vector4_partselection_12");
        $display("---------------------------------------------------------------");

        // Case 1: Corner Case - 全 0 
        {a,b,c,d,e,f} = 30'h0;
        repeat(1) @(posedge clk) ;
        check_result();

        // Case 2: Corner Case - 全 1 
        {a,b,c,d,e,f} = {30{1'b1}}; 
        repeat(1) @(posedge clk) ;
        check_result();

        // Case 3: Randomized Testing
        for (i = 0; i < 20; i = i + 1) begin
            a = $urandom; b = $urandom; c = $urandom; 
            d = $urandom; e = $urandom; f = $urandom;
            repeat(1) @(posedge clk) ;
            check_result();
        end

        $display("---------------------------------------------------------------");
        if (error_count == 0)
            $display("TEST PASSED: All vectors matched correctly!");
        else
            $display("TEST FAILED: Found %0d errors.", error_count);
        $display("---------------------------------------------------------------");
        
        $finish;
    end

    // Task: Self-Checking Logic
    // ==========================================
    task check_result;
        reg [31:0] expected_temp;
        reg [7:0] exp_w, exp_x, exp_y, exp_z;
        begin
            // Golden Model 
            expected_temp = {a, b, c, d, e, f, 1'b1, 1'b1};
            
            exp_w = expected_temp[31:24];
            exp_x = expected_temp[23:16];
            exp_y = expected_temp[15:8];
            exp_z = expected_temp[7:0];

            if ({w, x, y, z} !== expected_temp) begin
                $display("[ERROR] Time=%0t | Inputs: a=%h b=%h c=%h d=%h e=%h f=%h", $time, a, b, c, d, e, f);
                $display("        Expected: w=%h x=%h y=%h z=%h (Full: %h)", exp_w, exp_x, exp_y, exp_z, expected_temp);
                $display("        Got     : w=%h x=%h y=%h z=%h (Full: %h)", w, x, y, z, {w,x,y,z});
                error_count = error_count + 1;
            end else begin
                // $display("[PASS] Time=%0t | Full Vector: %h", $time, {w,x,y,z});
            end
        end
    endtask

endmodule