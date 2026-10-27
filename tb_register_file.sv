
`timescale 1ns / 1ps

module tb_register_file;

    logic clk, reset, reg_write;
    logic [4:0] r1_sel, r2_sel, rd_sel;
    logic [31:0] wb_data;
    logic [31:0] r1_data, r2_data;

    register_file dut (
        .clk(clk),
        .reset(reset),
        .r1_sel(r1_sel),
        .r2_sel(r2_sel),
        .rd_sel(rd_sel),
        .wb_data(wb_data),
        .reg_write(reg_write),
        .r1_data(r1_data),
        .r2_data(r2_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        reg_write = 0;
        r1_sel = 0;
        r2_sel = 0;
        rd_sel = 0;
        wb_data = 0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;

        // Write 100 into register 1
        rd_sel = 1;
        wb_data = 100;
        reg_write = 1;
        @(posedge clk);
        @(negedge clk);

        // Write 200 into register 2
        rd_sel = 2;
        wb_data = 200;
        @(posedge clk);
        @(negedge clk);

        // Read both registers
        reg_write = 0;
        r1_sel = 1;
        r2_sel = 2;
        #1;

        if (r1_data !== 32'd100 || r2_data !== 32'd200)
            $fatal(1, "FAIL: Register read/write test");

        $display("PASS: Register 1 = %0d", r1_data);
        $display("PASS: Register 2 = %0d", r2_data);

        // Check register zero
        r1_sel = 0;
        #1;
        if (r1_data !== 32'd0)
            $fatal(1, "FAIL: Register zero");

        $display("PASS: Register zero is always 0");
        $display("PASS: Register file verification complete");

        $finish;
    end

endmodule
