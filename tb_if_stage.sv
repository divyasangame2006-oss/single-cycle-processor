
`timescale 1ns / 1ps

module tb_if_stage;

    logic clk;
    logic reset;
    logic [31:0] pc;
    logic [31:0] instruction;

    if_stage dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        repeat (2) @(posedge clk);
        #1;

        if (pc !== 32'd0)
            $fatal(1, "FAIL: PC reset");
        $display("PASS: PC reset = %0d", pc);

        @(negedge clk);
        reset = 0;
        #1;

        if (instruction !== 32'h00500093)
            $fatal(1, "FAIL: Instruction at PC=0");
        $display("PASS: PC=%0d Instruction=%h", pc, instruction);

        @(posedge clk); #1;
        if (pc !== 32'd4 || instruction !== 32'h00A00113)
            $fatal(1, "FAIL: Instruction at PC=4");
        $display("PASS: PC=%0d Instruction=%h", pc, instruction);

        @(posedge clk); #1;
        if (pc !== 32'd8 || instruction !== 32'h002081B3)
            $fatal(1, "FAIL: Instruction at PC=8");
        $display("PASS: PC=%0d Instruction=%h", pc, instruction);

        @(posedge clk); #1;
        if (pc !== 32'd12 || instruction !== 32'h00302023)
            $fatal(1, "FAIL: Instruction at PC=12");
        $display("PASS: PC=%0d Instruction=%h", pc, instruction);

        $display("PASS: IF stage verification complete");
        $finish;
    end

endmodule
