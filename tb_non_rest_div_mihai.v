module tb_non_rest_div_mihai;

    reg clk;
    reg reset;
    reg start;
    reg signed [7:0] a;
    reg signed [7:0] b;
    wire signed [15:0] quotient;
    wire signed [15:0] remainder; 
    wire done;

    // Instanțiere modul testat
    non_rest_div uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .quotient(quotient),
        .remainder(remainder), 
        .done(done)
    );

    // Generare ceas
    always #5 clk = ~clk;

    // Task pentru a face un test
    task perform_test(input signed [7:0] op_a, input signed [7:0] op_b);
        begin
            @(negedge clk);
            a <= op_a;
            b <= op_b;
            start <= 1;
            @(negedge clk);
            start <= 0;

            // Așteaptă să se termine calculul
            wait (done == 1);

            // Afișează rezultatul
            $display("a = %d, b = %d => quotient = %d, remainder = %d", op_a, op_b, quotient, remainder);
        end
    endtask

    // Secvență principală de test
    initial begin
        $display("=== Pornire Testbench pentru non_rest_div ===");
        clk = 0;
        reset = 1;
        start = 0;
        a = 0;
        b = 0;

        // Ține reset activ câteva cicluri
        #10;
        @(negedge clk); reset = 0;

        // Cazuri de test
        perform_test(25, 5);      // 25 / 5 = 5 rest 0
        perform_test(-25, 5);     // -25 / 5 = -5 rest 0
        perform_test(25, -5);     // 25 / -5 = -5 rest 0
        perform_test(-25, -5);    // -25 / -5 = 5 rest 0
        perform_test(0, 5);       // 0 / 5 = 0 rest 0
        perform_test(5, 0);       // 5 / 0 = 0 rest 0 (manevrare div. 0)
        perform_test(127, 3);     // 127 / 3 = 42 rest 1
        perform_test(-128, 7);    // -128 / 7 = -18 rest 2
        perform_test(54, 7);      // 54 / 7 = 7 rest 5
        perform_test(-54, 7);     // -54 / 7 = -7 rest 5

        $display("=== Toate testele au fost executate ===");
        $finish;
    end

endmodule
