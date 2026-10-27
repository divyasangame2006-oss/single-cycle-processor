
module if_stage (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc,
    output logic [31:0] instruction
);

    logic [31:0] imem [0:15];
    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1)
            imem[i] = 32'h00000013;

        imem[0] = 32'h00500093;
        imem[1] = 32'h00A00113;
        imem[2] = 32'h002081B3;
        imem[3] = 32'h00302023;
        imem[4] = 32'h00002203;
    end

    always_ff @(posedge clk) begin
        if (reset)
            pc <= 32'd0;
        else
            pc <= pc + 32'd4;
    end

    always_comb begin
        if (pc[31:6] == 0)
            instruction = imem[pc[5:2]];
        else
            instruction = 32'h00000013;
    end

endmodule
