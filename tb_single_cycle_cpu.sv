
`timescale 1ns / 1ps

module tb_single_cycle_cpu;

    logic clk;
    logic reset;
    wire [31:0] pc;
    wire [31:0] instruction;

    single_cycle_cpu dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Hold reset for two clock cycles
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;

        // Execute five instructions
        repeat (5) begin
            @(posedge clk);
            #1;
            $display("PC=%0d Instruction=%h", pc, instruction);
        end

        // Check final program counter
        if (pc !== 32'd20)
            $fatal(1, "FAIL: Program counter");

        // Check results of ADDI and ADD
        if (dut.registers[1] !== 32'd5)
            $fatal(1, "FAIL: x1 should be 5");

        if (dut.registers[2] !== 32'd10)
            $fatal(1, "FAIL: x2 should be 10");

        if (dut.registers[3] !== 32'd15)
            $fatal(1, "FAIL: x3 should be 15");

        if (dut.registers[4] !== 32'd15)
            $fatal(1, "FAIL: x4 should be 15");

        if (dut.data_mem[0] !== 32'd15)
            $fatal(1, "FAIL: data memory word 0 should be 15");

        $display("PASS: x1 = 5");
        $display("PASS: x2 = 10");
        $display("PASS: x3 = 15");
        $display("PASS: SW/LW memory test");
        $display("PASS: Single-cycle CPU test completed");

        $finish;
    end

endmodule
