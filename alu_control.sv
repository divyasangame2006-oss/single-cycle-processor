
module alu_control (
    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] alu_control_signal
);

    always_comb begin
        case (alu_op)
            // Load/store: ADD
            2'b00: alu_control_signal = 4'b0000;

            // Branch: SUB
            2'b01: alu_control_signal = 4'b0001;

            // R-type and I-type arithmetic
            2'b10: begin
                case (funct3)
                    3'b000:
                        alu_control_signal =
                            (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000;
                    3'b111: alu_control_signal = 4'b0010; // AND
                    3'b110: alu_control_signal = 4'b0011; // OR
                    3'b100: alu_control_signal = 4'b0100; // XOR
                    3'b010: alu_control_signal = 4'b0101; // SLT
                    3'b001: alu_control_signal = 4'b0110; // SLL
                    3'b101:
                        alu_control_signal =
                            (funct7 == 7'b0100000) ? 4'b1000 : 4'b0111;
                    default: alu_control_signal = 4'b0000;
                endcase
            end

            default: alu_control_signal = 4'b0000;
        endcase
    end

endmodule
