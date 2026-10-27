
`timescale 1ns / 1ps

module tb_alu;

    logic [31:0] a, b;
    logic [3:0] alu_control;
    logic [31:0] result;
    logic zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        // ADD: 10 + 5 = 15
        a = 10; b = 5; alu_control = 4'b0000;
        #10;
        if (result !== 32'd15) $fatal(1, "ADD failed");
        $display("PASS: ADD");

        // SUB: 10 - 5 = 5
        alu_control = 4'b0001;
        #10;
        if (result !== 32'd5) $fatal(1, "SUB failed");
        $display("PASS: SUB");

        // AND
        a = 32'hF0; b = 32'h3C; alu_control = 4'b0010;
        #10;
        if (result !== 32'h30) $fatal(1, "AND failed");
        $display("PASS: AND");

        // OR
        alu_control = 4'b0011;
        #10;
        if (result !== 32'hFC) $fatal(1, "OR failed");
        $display("PASS: OR");

        // SLT: 3 < 5
        a = 3; b = 5; alu_control = 4'b0101;
        #10;
        if (result !== 32'd1) $fatal(1, "SLT failed");
        $display("PASS: SLT");

        // Zero flag
        a = 5; b = 5; alu_control = 4'b0001;
        #10;
        if (result !== 0 || zero !== 1)
            $fatal(1, "Zero flag failed");
        $display("PASS: Zero flag");

        $display("ALU tests completed successfully");
        $finish;
    end

endmodule
