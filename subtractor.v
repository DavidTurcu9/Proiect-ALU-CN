module subtractor(
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output cout
);
    wire [7:0] b_inverted;
    wire [7:0] sum;
    wire add_cout;

    // Invert B for 2's complement
    assign b_inverted = ~b;

    // Create a new adder
    adder add_sub (
        .a(a),
        .b(b_inverted),
        .sum(sum),
        .cout(add_cout)
    );

    // Add 1 to complete 2's complement
    assign diff = sum + 1;
    assign cout = add_cout;

endmodule