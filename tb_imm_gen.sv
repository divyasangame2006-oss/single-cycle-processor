
`timescale 1ns / 1ps

module tb_imm_gen;

    logic [31:0] instruction;
    logic [31:0] immediate;

    imm_gen dut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin
        // I-type: ADDI x1, x0, 5
        instruction = 32'h00500093;
        #10;
        if (immediate !== 32'd5)
            $fatal(1, "FAIL: I-type immediate");
        $display("PASS: I-type immediate = %0d", immediate);

        // S-type: SW x3, 0(x0)
        instruction = 32'h00302023;
        #10;
        if (immediate !== 32'd0)
            $fatal(1, "FAIL: S-type immediate");
        $display("PASS: S-type immediate = %0d", immediate);

        // U-type: LUI x1, 0x12345
        instruction = 32'h123450B7;
        #10;
        if (immediate !== 32'h12345000)
            $fatal(1, "FAIL: U-type immediate");
        $display("PASS: U-type immediate = %h", immediate);

        $display("PASS: Immediate generator tests complete");
        $finish;
    end

endmodule
