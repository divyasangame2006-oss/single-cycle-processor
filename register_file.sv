
module register_file (
    input  logic        clk,
    input  logic        reset,
    input  logic [4:0]  r1_sel,
    input  logic [4:0]  r2_sel,
    input  logic [4:0]  rd_sel,
    input  logic [31:0] wb_data,
    input  logic        reg_write,
    output logic [31:0] r1_data,
    output logic [31:0] r2_data
);

    logic [31:0] registers [0:31];
    integer i;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && rd_sel != 5'd0) begin
            registers[rd_sel] <= wb_data;
        end
    end

    always_comb begin
        r1_data = (r1_sel == 5'd0) ? 32'b0 : registers[r1_sel];
        r2_data = (r2_sel == 5'd0) ? 32'b0 : registers[r2_sel];
    end

endmodule
