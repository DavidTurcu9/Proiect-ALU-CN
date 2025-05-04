`timescale 1ns/1ps

module alu_top2_tb;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;

    // Outputs
    wire [15:0] result;
    wire [2:0] state;

    // Instantiate the Unit Under Test (UUT)
    alu_top2 uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .state(state)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period

    // Test sequence
    initial begin
        $display("Starting ALU Testbench");
        clk = 0;
        rst = 0;
        start = 0;
        a = 0;
        b = 0;
        op = 2'b00;

        #10 rst = 1;  // Deassert reset

        // Test ADD
        a = 8'd10;
        b = 8'd5;
        op = 2'b00;
        start = 1;
        #10 start = 0;
        wait (state == 3'b000); // Wait for IDLE
        #10 $display("ADD Result: %d", result);

        // Test SUB
        a = 8'd15;
        b = 8'd8;
        op = 2'b01;
        start = 1;
        #10 start = 0;
        wait (state == 3'b000);
        #10 $display("SUB Result: %d", result);

        // Test MUL
        a = 8'd3;
        b = 8'd4;
        op = 2'b10;
        start = 1;
        #10 start = 0;
        wait (state == 3'b000);
        #10 $display("MUL Result: %d", result);

        $finish;
    end

endmodule
