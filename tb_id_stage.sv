
`timescale 1ns / 1ps

module tb_id_stage;

    logic [31:0] instruction;
    logic [6:0] opcode;
    logic [4:0] rd, rs1, rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] immediate;

    id_stage dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .immediate(immediate)
    );

    initial begin
        // Test 1: ADDI x1, x0, 5
        instruction = 32'h00500093;
        #10;

        if (opcode !== 7'h13 ||
            rd !== 5'd1 ||
            rs1 !== 5'd0 ||
            immediate !== 32'd5)
            $fatal(1, "FAIL: ADDI decode");

        $display("PASS: ADDI decode");

        // Test 2: ADD x3, x1, x2
        instruction = 32'h002081B3;
        #10;

        if (opcode !== 7'h33 ||
            rd !== 5'd3 ||
            rs1 !== 5'd1 ||
            rs2 !== 5'd2 ||
            funct3 !== 3'b000 ||
            funct7 !== 7'b0000000)
            $fatal(1, "FAIL: ADD decode");

        $display("PASS: ADD decode");
        $display("PASS: ID stage verification complete");

        $finish;
    end

endmodule
