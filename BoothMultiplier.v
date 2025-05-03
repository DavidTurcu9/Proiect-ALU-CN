module BoothMultiplier (
    input clk,
    input start,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output reg [15:0] outbus,
    output reg done
);
    reg signed [7:0] M, Q;
    reg signed [8:0] A; // 9-bit pentru overflow
    reg Qm1;
    reg [2:0] COUNT;

    reg [2:0] state;

    localparam S_IDLE   = 3'd0,
               S_INIT   = 3'd1,
               S_EXEC   = 3'd2,
               S_SHIFT  = 3'd3,
               S_COUNT  = 3'd4,
               S_DONE   = 3'd5;

    always @(posedge clk) begin
        case (state)
            S_IDLE: begin
                done <= 0;
                if (start)
                    state <= S_INIT;
            end

            S_INIT: begin
                A <= 9'd0;
                Q <= multiplier;
                M <= multiplicand;
                Qm1 <= 1'b0;
                COUNT <= 3'd0;
                state <= S_EXEC;
            end

            S_EXEC: begin
                case ({Q[0], Qm1})
                    2'b01: A <= A + M;  
                    2'b10: A <= A - M;  
                    default: ; 
                endcase
                state <= S_SHIFT;
            end

            S_SHIFT: begin
                
                {A, Q, Qm1} <= {A[8], A, Q, Qm1} >>> 1;
                state <= S_COUNT;
            end

            S_COUNT: begin
                COUNT <= COUNT + 1;
                if (COUNT == 3'd7)
                    state <= S_DONE;
                else
                    state <= S_EXEC;
            end

            S_DONE: begin
                outbus <= {A[7:0], Q}; 
                done <= 1;
                state <= S_IDLE;
            end

            default: state <= S_IDLE;
        endcase
    end
endmodule
