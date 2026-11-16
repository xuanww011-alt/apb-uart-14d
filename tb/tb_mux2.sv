`timescale 1ns/1ps
module tb_mux2;
    reg [7:0] a, b;
    reg       sel;
    wire [7:0] y;
    mux2 dut(.a(a),.b(b),.sel(sel),.y(y));
    initial begin
        $dumpfile("build/tb_mux2.vcd");
        $dumpvars(0, tb_mux2);
        a=8'hA5; b=8'h3C; sel=1'b0; #1;
        if (y !== a) $fatal(1, "mux2 sel=0 failed");
        sel=1'b1; #1;
        if (y !== b) $fatal(1, "mux2 sel=1 failed");
        a=8'h00; b=8'hFF; sel=1'b0; #1;
        if (y !== a) $fatal(1, "mux2 zero case failed");
        sel=1'b1; #1;
        if (y !== b) $fatal(1, "mux2 full ones case failed");
        $display("[PASS] mux2 smoke test: 4 directed cases");
        $finish;
    end
endmodule
