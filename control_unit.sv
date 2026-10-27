
module control_unit (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       alu_src,
    output logic       branch,
    output logic       jump,
    output logic [1:0] alu_op
);

    always_comb begin
        reg_write = 0;
        mem_read  = 0;
        mem_write = 0;
        mem_to_reg = 0;
        alu_src   = 0;
        branch    = 0;
        jump      = 0;
        alu_op    = 2'b00;

        case (opcode)
            // R-type arithmetic
            7'b0110011: begin
                reg_write = 1;
                alu_op = 2'b10;
            end

            // I-type arithmetic
            7'b0010011: begin
                reg_write = 1;
                alu_src = 1;
                alu_op = 2'b10;
            end

            // Load
            7'b0000011: begin
                reg_write = 1;
                mem_read = 1;
                mem_to_reg = 1;
                alu_src = 1;
                alu_op = 2'b00;
            end

            // Store
            7'b0100011: begin
                mem_write = 1;
                alu_src = 1;
                alu_op = 2'b00;
            end

            // Branch
            7'b1100011: begin
                branch = 1;
                alu_op = 2'b01;
            end

            // JAL
            7'b1101111: begin
                reg_write = 1;
                jump = 1;
            end

            // LUI
            7'b0110111: begin
                reg_write = 1;
                alu_src = 1;
            end

            default: begin
                // Keep all controls inactive
            end
        endcase
    end

endmodule
