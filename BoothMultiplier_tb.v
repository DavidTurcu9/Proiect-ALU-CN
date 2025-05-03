module BoothMultiplier_tb;
    reg clk, start;
    reg [7:0] multiplicand, multiplier;
    wire [15:0] outbus;
    wire done;

    BoothMultiplier uut (
        .clk(clk),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .outbus(outbus),
        .done(done)
    );


    always #5 clk = ~clk;

    initial begin
        $display("Start Booth Multiplier");
        clk = 0;
        start = 0;

        // Test 1: 5 * 10 = 50
        multiplicand = 8'd10;
        multiplier   = 8'd5;
        run_test("5 * 10");

        // Test 2: -3 * 7 = -21
        multiplicand = 8'b11111101; // -3 in C2
        multiplier   = 8'd7;
        run_test("-3 * 7");

        // Test 3: 4 * -6 = -24
        multiplicand = 8'd4;
        multiplier   = 8'b11111010; // -6 in C2
        run_test("4 * -6");

        // Test 4: -5 * -5 = 25
        multiplicand = 8'b11111011; // -5
        multiplier   = 8'b11111011; // -5
        run_test("-5 * -5");

        // Test 5: -8 * 0 = 0
        multiplicand = 8'b11111000; // -8
        multiplier   = 8'd0;
        run_test("-8 * 0");

        $finish;
    end

    task run_test(input [127:0] testname);
        begin
            $display("\n--- Test: %s ", testname);
            #10;
            start = 1;
            #10;
            start = 0;

            wait(done == 1);
            $display("Result = %0d (bin = %016b)", $signed(outbus), outbus);
        end
    endtask
endmodule 
