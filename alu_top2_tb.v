module alu_top2_tb;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire [15:0] result;
    wire [2:0] state;

    // Instantiate the ALU
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
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Stimulus
    initial begin
        $display("Starting ALU testbench...");
        rst = 0;
        start = 0;
        a = 0;
        b = 0;
        op = 2'b00;

        #20 rst = 1; // release reset

        // ADD TEST CASES
        test_alu(8'd20, 8'd10, 2'b00);     // 20 + 10 = 30
        test_alu(-8'd10, 8'd5, 2'b00);     // -10 + 5 = -5
        test_alu(-8'd50, -8'd30, 2'b00);   // -50 + (-30) = -80

        // SUB TEST CASES
        test_alu(8'd20, 8'd10, 2'b01);     // 20 - 10 = 10
        test_alu(8'd10, 8'd20, 2'b01);     // 10 - 20 = -10
        test_alu(-8'd40, 8'd20, 2'b01);    // -40 - 20 = -60

        // MUL TEST CASES
        test_alu(8'd5, 8'd4, 2'b10);       // 5 * 4 = 20
        test_alu(-8'd6, 8'd3, 2'b10);      // -6 * 3 = -18
        test_alu(-8'd7, -8'd7, 2'b10);     // -7 * -7 = 49

        // DIV TEST CASES
        test_alu(8'd40, 8'd5, 2'b11);      // 40 / 5 = 8
        test_alu(-8'd40, 8'd5, 2'b11);     // -40 / 5 = -8
        test_alu(8'd40, -8'd8, 2'b11);     // 40 / -8 = -5
        test_alu(-8'd20, -8'd4, 2'b11);    // -20 / -4 = 5

        $display("ALU testbench complete.");
        $finish;
    end

    task test_alu(input signed [7:0] val_a, input signed [7:0] val_b, input [1:0] operation);
        begin
            @(negedge clk);
            a = val_a;
            b = val_b;
            op = operation;
            start = 1;

            @(negedge clk);
            start = 0;

            // Wait until ALU goes back to IDLE (state == 0)
            wait (state == 3'b000);

            @(negedge clk); // sync one more clock
            $display("a = %d, b = %d, op = %b -> result = %d", val_a, val_b, operation, $signed(result));
        end
    endtask

endmodule
