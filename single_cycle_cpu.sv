
module single_cycle_cpu (
    input logic clk,
    input logic reset,
    output logic [31:0] pc,
    output logic [31:0] instruction
);

    logic [31:0] imem [0:15];
    logic [31:0] registers [0:31];
    logic [31:0] data_mem [0:255];

    logic [6:0] opcode;
    logic [4:0] rd, rs1, rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] immediate;
    logic [31:0] operand_a, operand_b;
    logic [31:0] alu_result;
    logic [31:0] next_pc;
    logic [3:0] alu_control_signal;
    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1)
            imem[i] = 32'h00000013;

        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;

        for (i = 0; i < 256; i = i + 1)
            data_mem[i] = 32'b0;

        imem[0] = 32'h00500093; // ADDI x1,x0,5
        imem[1] = 32'h00A00113; // ADDI x2,x0,10
        imem[2] = 32'h002081B3; // ADD x3,x1,x2
        imem[3] = 32'h00302023; // SW x3,0(x0)
        imem[4] = 32'h00002203; // LW x4,0(x0)
    end

    assign instruction = imem[pc[5:2]];

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct7 = instruction[31:25];

    imm_gen imm_unit (
        .instruction(instruction),
        .immediate(immediate)
    );

    always_comb begin
        operand_a = (rs1 == 0) ? 32'b0 : registers[rs1];

        case (opcode)
            7'b0110011: operand_b =
                (rs2 == 0) ? 32'b0 : registers[rs2];
            default: operand_b = immediate;
        endcase

        alu_control_signal = 4'b0000;

        case (opcode)
            7'b0110011, 7'b0010011: begin
                case (funct3)
                    3'b000:
                        alu_control_signal =
                            (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000;
                    3'b111: alu_control_signal = 4'b0010;
                    3'b110: alu_control_signal = 4'b0011;
                    3'b100: alu_control_signal = 4'b0100;
                    3'b010: alu_control_signal = 4'b0101;
                    default: alu_control_signal = 4'b0000;
                endcase
            end
            default: alu_control_signal = 4'b0000;
        endcase

        case (alu_control_signal)
            4'b0000: alu_result = operand_a + operand_b;
            4'b0001: alu_result = operand_a - operand_b;
            4'b0010: alu_result = operand_a & operand_b;
            4'b0011: alu_result = operand_a | operand_b;
            4'b0100: alu_result = operand_a ^ operand_b;
            4'b0101: alu_result =
                ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            default: alu_result = 32'b0;
        endcase
    end

    always_comb begin
        next_pc = pc + 32'd4;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0;
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else begin
            pc <= next_pc;

            if (opcode == 7'b0100011) begin
                if (alu_result[1:0] == 2'b00)
                    data_mem[alu_result[9:2]] <=
                        (rs2 == 0) ? 32'b0 : registers[rs2];
            end
            else if (opcode == 7'b0000011) begin
                if (rd != 0 && alu_result[1:0] == 2'b00)
                    registers[rd] <= data_mem[alu_result[9:2]];
            end
            else if (opcode == 7'b0110011 ||
                     opcode == 7'b0010011) begin
                if (rd != 0)
                    registers[rd] <= alu_result;
            end

            registers[0] <= 32'b0;
        end
    end

endmodule
