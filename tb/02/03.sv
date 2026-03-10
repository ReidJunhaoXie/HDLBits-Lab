`timescale 1ns/1ps

module tb_ModuleShift8;

    logic clk;
    logic [7:0] d;
    logic [1:0] sel;
    logic [7:0] q;

    parameter CLK_PERIOD = 10; // 100MHz

    ModuleShift8_03 dut (
        .clk(clk),
        .d(d),
        .sel(sel),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Golden Reference Model
    logic [7:0] pipe_ref [0:2]; //  pipeline + d 

    //  Reference Model
    always @(posedge clk) begin
        pipe_ref[2] <= pipe_ref[1];
        pipe_ref[1] <= pipe_ref[0];
        pipe_ref[0] <= d; 
    end

    // Test 
    initial begin
        $display("---------------------------------------------------");
        $display("[%t] Simulation Start", $time);
        d = 0;
        sel = 0;
        
        // Flush pipeline
        repeat(5) @(negedge clk);

        $display("---------------------------------------------------");
        $display("[TEST CASE 1] Directed Select Test");

        // drive_stimulus --> data(d/sel)
        // check_output --> MUX circuit        
        //  Bypass (Sel=0)
        drive_stimulus(8'hAA, 2'b00); 
        #(CLK_PERIOD/4) ;
        check_output();
        drive_stimulus(8'hBB, 2'b01);
        #(CLK_PERIOD/4) ;
        check_output();
        drive_stimulus(8'hCC, 2'b10);
        #(CLK_PERIOD/4) ;
        check_output();
        drive_stimulus(8'hDD, 2'b11);
        #(CLK_PERIOD/4) ;
        check_output();

        // Random Stress Test
        $display("---------------------------------------------------");
        $display("[TEST CASE 2] Random Stress Test");
        
        repeat(20) begin
            // Neg drive` 
            @(negedge clk);

            // std::randomize  SystemVerilog random function 
            {sel, d} = $urandom(); 
            
 
            #(CLK_PERIOD/4); 
            check_output();
        end

        $display("---------------------------------------------------");
        $display("[%t] All Tests Passed! Simulation Finished.", $time);
        $finish;
    end

    // Tasks
    task drive_stimulus(input [7:0] in_data, input [1:0] in_sel);
        @(negedge clk); // When neg edge drive the data to meet Setup time
        d = in_data;
        sel = in_sel;
    endtask

    // Scoreboard logic
    task check_output;
        logic [7:0] expected_val;
        case(sel)
            2'b00: expected_val = d;           // Bypass
            2'b01: expected_val = pipe_ref[0]; // Delay 1 
            2'b10: expected_val = pipe_ref[1]; // Delay 2
            2'b11: expected_val = pipe_ref[2]; // Delay 3
        endcase

        // Assertion check
        if (q !== expected_val) begin
            $error("[%t] ERROR! sel=%b, d=0x%h. Expected 0x%h, but got 0x%h", 
                    $time, sel, d, expected_val, q);
             $stop; 
        end else begin
            $display("[%t] PASS: sel=%b, d=0x%h, q=0x%h (Matches History)", 
                     $time, sel, d, q);
        end
    endtask

endmodule

