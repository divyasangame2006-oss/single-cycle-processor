
`timescale 1ns / 1ps

module tb_control_unit;

    logic [6:0] opcode;
    logic reg_write, mem_read, mem_write;
    logic mem_to_reg, alu_src, branch, jump;
    logic [1:0] alu_op;

    control_unit dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    initial begin
        // R-type: ADD
        opcode = 7'b0110011;
        #10;
        if (reg_write !== 1 || alu_op !== 2'b10)
            $fatal(1, "R-type control failed");
        $display("PASS: R-type");

        // Load: LW
        opcode = 7'b0000011;
        #10;
        if (reg_write !== 1 || mem_read !== 1 ||
            mem_to_reg !== 1 || alu_src !== 1)
            $fatal(1, "Load control failed");
        $display("PASS: Load");

        // Store: SW
        opcode = 7'b0100011;
        #10;
        if (mem_write !== 1 || alu_src !== 1)
            $fatal(1, "Store control failed");
        $display("PASS: Store");

        // Branch
        opcode = 7'b1100011;
        #10;
        if (branch !== 1 || alu_op !== 2'b01)
            $fatal(1, "Branch control failed");
        $display("PASS: Branch");

        $display("Control unit tests completed");
        $finish;
    end

endmodule
