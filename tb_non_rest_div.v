module tb_non_rest_div;

    reg clk;
    reg reset;
    reg start;
    reg signed [7:0] a;
    reg signed [7:0] b;
    wire signed [15:0] quotient;
    wire done;

    // Instantiate the module under test
    non_rest_div uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .quotient(quotient),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to apply test
    task perform_test(input signed [7:0] op_a, input signed [7:0] op_b);
        begin
            @(negedge clk);
            a <= op_a;
            b <= op_b;
            start <= 1;
            @(negedge clk);
            start <= 0;

            // Wait for done signal
            wait (done == 1);
            $display("a = %d, b = %d, quotient = %d", op_a, op_b, quotient);
        end
    endtask

    // Main test sequence
    initial begin
        $display("Starting Testbench for non_rest_div");
        clk = 0;
        reset = 1;
        start = 0;
        a = 0;
        b = 0;

        // Hold reset for a few cycles
        #10;
        @(negedge clk); reset = 0;

        // Perform several test cases
        perform_test(25, 5);    // 25 / 5 = 5
        perform_test(-25, 5);   // -25 / 5 = -5
        perform_test(25, -5);   // 25 / -5 = -5
        perform_test(-25, -5);  // -25 / -5 = 5
        perform_test(0, 5);     // 0 / 5 = 0
        perform_test(5, 0);     // 5 / 0 = 0 (division by zero)
        perform_test(127, 3);   // 127 / 3 = 42
        perform_test(-128, 7);  // -128 / 7 = -18
        perform_test(54, 7);    // 54 / 7 = 7 rest 5
        perform_test(-54, 7);    // -54 / 7 = -7 rest 5

        $display("All tests completed.");
        $finish;
    end

endmodule