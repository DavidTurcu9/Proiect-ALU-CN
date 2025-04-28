module alu_tb;

    // Inputs for Adder and Subtractor
    reg [7:0] a, b;
    
    // Outputs for Adder and Subtractor
    wire [7:0] sum, diff;
    wire carry_out_add, carry_out_sub;

    // Instantiate the Adder
    adder add_inst (
        .a(a),
        .b(b),
        .sum(sum),
        .cout(carry_out_add)
    );
    
    // Instantiate the Subtractor
    subtractor sub_inst (
        .a(a),
        .b(b),
        .diff(diff),
        .cout(carry_out_sub)
    );
    
    initial begin
        // Initialize the inputs
        a = 8'd0; b = 8'd0;
        
        // Display the header for the test
        $display("Time\t a\t b\t sum\t carry_out_add\t diff\t carry_out_sub");

        // Test Case 1: Simple Addition and Subtraction
        a = 8'd15; b = 8'd10;
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 2: Addition with Overflow and Subtraction
        a = 8'd255; b = 8'd1; // Expect overflow in addition
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 3: Subtraction with Borrow
        a = 8'd10; b = 8'd15; // Expect borrow in subtraction
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 4: Zero Addition and Subtraction
        a = 8'd0; b = 8'd0;
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 5: Negative Result (Subtraction)
        a = 8'd50; b = 8'd100; // Expect negative result
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // Test Case 6: Addition of Maximum Values
        a = 8'd255; b = 8'd255; // Test maximum values
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);

        // Test Case 7: Random Values
        a = 8'd123; b = 8'd200;
        #10;
        $display("%0t\t %d\t %d\t %d\t %b\t %d\t %b", $time, a, b, sum, carry_out_add, diff, carry_out_sub);
        
        // End of simulation
        $finish;
    end
endmodule
