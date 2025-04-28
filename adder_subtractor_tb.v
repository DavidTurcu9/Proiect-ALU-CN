module alu_tb;

    // Declare 8-bit signed registers for inputs
    reg signed [7:0] a, b;  // Inputs a and b are signed 8-bit
    wire signed [7:0] sum, diff;  // Sum and diff are signed 8-bit outputs
    wire carry_out_add, carry_out_sub;  // Carry-out signals

    // Instantiate the signed Adder
    adder add_inst (
        .a(a),
        .b(b),
        .sum(sum),
        .cout(carry_out_add)
    );
    
    // Instantiate the signed Subtractor
    subtractor sub_inst (
        .a(a),
        .b(b),
        .diff(diff),
        .cout(carry_out_sub)
    );
    
    initial begin
        // Display the header for the test (in binary format)
        $display("Time\t a\t\t b\t\t sum\t\t carry_out_add\t diff\t\t carry_out_sub");
        
        // Test Case 1: Simple Addition and Subtraction (positive numbers)
        a = 8'sd15; b = 8'sd10;  // signed 15 and 10
        #10;
        $display("%0t\t %b\t %b\t %b\t %b\t\t %b\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 2: Addition with Overflow and Subtraction
        a = 8'sd127; b = 8'sd1;  // Overflow in addition (127 + 1 = 128, out of range)
        #10;
        $display("%0t\t %b\t %b\t %b\t %b\t\t %b\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 3: Subtraction with Borrow
        a = 8'sd10; b = 8'sd20;  // Expect borrow in subtraction (10 - 20 = -10, borrow should occur)
        #10;
        $display("%0t\t %b\t %b\t %b\t %b\t\t %b\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 4: Negative Addition and Subtraction
        a = 8'sd50; b = -100; // Signed negative number, expect negative result
        #10;
        $display("%0t\t %b\t %b\t %b\t %b\t\t %b\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 5: Maximum Values for Addition and Subtraction
        a = 8'sd127; b = 8'sd127; // Test max signed values
        #10;
        $display("%0t\t %b\t %b\t %b\t %b\t\t %b\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 6: Random Signed Values
        a = -50; b = 8'sd30;  // Signed values, check addition and subtraction
        #10;
        $display("%0t\t %b\t %b\t %b\t %b\t\t %b\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // End of simulation
        $finish;
    end
endmodule
