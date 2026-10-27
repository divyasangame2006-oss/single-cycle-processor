
`timescale 1ns / 1ps

module tb_alu_control;

    logic [1:0] alu_op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [3:0] alu_control_signal;

    alu_control dut (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control_signal(alu_control_signal)
    );

    initial begin
        // Load/store: ADD
        alu_op = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_control_signal !== 4'b0000)
            $fatal(1, "FAIL: ADD control");
        $display("PASS: ADD control");

        // Branch: SUB
        alu_op = 2'b01;
        #10;
        if (alu_control_signal !== 4'b0001)
            $fatal(1, "FAIL: SUB control");
        $display("PASS: SUB control");

        // R-type AND
        alu_op = 2'b10;
        funct3 = 3'b111;
        #10;
        if (alu_control_signal !== 4'b0010)
            $fatal(1, "FAIL: AND control");
        $display("PASS: AND control");

        // R-type OR
        funct3 = 3'b110;
        #10;
        if (alu_control_signal !== 4'b0011)
            $fatal(1, "FAIL: OR control");
        $display("PASS: OR control");

        $display("PASS: ALU control tests complete");
        $finish;
    end

endmodule
