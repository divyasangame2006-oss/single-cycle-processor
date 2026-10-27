
`timescale 1ns / 1ps

module tb_data_memory;

    logic clk;
    logic mem_read;
    logic mem_write;
    logic [31:0] address;
    logic [31:0] write_data;
    logic [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;

        // Write 123 into word address 0
        @(negedge clk);
        address = 32'd0;
        write_data = 32'd123;
        mem_write = 1;

        @(posedge clk);
        @(negedge clk);
        mem_write = 0;
        mem_read = 1;
        #1;

        if (read_data !== 32'd123)
            $fatal(1, "FAIL: Memory read/write");

        $display("PASS: Memory read/write = %0d", read_data);

        // Write 456 into byte address 4 (word 1)
        @(negedge clk);
        mem_read = 0;
        address = 32'd4;
        write_data = 32'd456;
        mem_write = 1;

        @(posedge clk);
        @(negedge clk);
        mem_write = 0;
        mem_read = 1;
        #1;

        if (read_data !== 32'd456)
            $fatal(1, "FAIL: Second memory location");

        $display("PASS: Second memory location = %0d", read_data);
        $display("PASS: Data memory verification complete");

        $finish;
    end

endmodule
