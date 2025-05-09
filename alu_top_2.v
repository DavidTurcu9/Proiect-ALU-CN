module alu_top2 (
    input clk,
    input rst,
    input start,
    input [7:0] a,  // 8-bit signed input a
    input [7:0] b,  // 8-bit signed input b
    input [1:0] op, // 2-bit operation select input (00: ADD, 01: SUB, 10: MUL, 11: DIV)
    output reg [15:0] result,
    output reg [2:0] state // for debug purpose
);


wire [8:0] sum_or_diff;
wire [15:0] adder_result, mult_result, div_result;
wire carry_out_add;
wire start_mult, start_div;
wire done_mult, done_div;
wire adder_op;

//reg [2:0] state;   commented pt ca am pus in output sus

assign adder_op = ~op[1] & op[0];  // if op is 01 subtract, adder_op becomes 1

// extend adder and subtractor results to 16 bits
assign adder_result = {{7{sum_or_diff[8]}},sum_or_diff};

assign start_mult = ~state[2] & state[1] & state[0];  // if in multiply state, start booth algorithm
assign start_div = ~state[2] & ~state[1] & state[0];  // if in divide state, start division algorithm

adder add_inst (
        .x(a),
        .y(b),
        .op(adder_op),
        .z(sum_or_diff)
);

BoothMultiplier booth_inst (
    .clk(clk),
    .start(start_mult),
    .multiplicand(a),
    .multiplier(b),
    .outbus(mult_result),
    .done(done_mult)
);

non_rest_div div_inst (
    .clk(clk),
    .reset(rst),
    .start(start_div),
    .a(a),
    .b(b),
    .quotient(div_result),
    .done(done_div)
);


initial begin
    state <= 0;
    result <= 0;
end

always @(posedge clk, negedge rst) begin
    if (!rst) begin
        state <= 3'b000;
        result <= 0;
    end else begin
        case (state)
            3'b000: begin  // IDLE
                result <= 0;
                if (start) begin
                    case (op)
                        2'b00: begin // ADD
                            state <= 3'b001;
                        end
                        2'b01: begin // SUBTRACT
                            state <= 3'b010;
                        end
                        2'b10: begin // MULTIPLY
                            state <= 3'b011;
                        end
                        2'b11: begin //DIVIDE
                            state <= 3'b100;
                        end
                    endcase
                end
            end

            // MATH OPERATIONS
            3'b001: begin // ADD
                result <= adder_result;
                state <= 3'b000; // bypass output state
            end
            3'b010: begin // SUBTRACT
                result <= adder_result;
                state <= 3'b000; // bypass output state
            end
            3'b011: begin // MULTIPLY
                if (done_mult) begin
                    result <= mult_result;
                    state <= 3'b101; // go to output
                end
            end
            3'b100: begin // DIVIDE
                if (done_div) begin
                    result <= div_result;
                    state <= 3'b101; // go to output
                end
            end

            3'b101: begin // OUTPUT(only for multiplication and division)
                state <= 3'b000; // go to idle
            end
        endcase
    end

end

endmodule