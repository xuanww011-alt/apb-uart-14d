`timescale 1ns/1ps
module tb_mux4_exercise;
    reg [7:0] a, b, c, d;
    reg [1:0] sel;
    wire [7:0] y;
    integer i;
    mux4_exercise dut(.a(a),.b(b),.c(c),.d(d),.sel(sel),.y(y));
    initial begin
        $dumpfile("build/tb_mux4.vcd");	//指定 VCD 文件的保存路径
        $dumpvars(0,tb_mux4_exercise);
        a=8'h12; b=8'h34; c=8'h56; d=8'h78;
        for (i=0; i<4; i=i+1) begin
            sel=i[1:0]; #1;
            case (i)
               0: if(y !== a) $fatal(1, "mux4 sel0 failed");
               1: if(y !== b) $fatal(1, "mux4 sel1 failed");
               2: if(y !== c) $fatal(1, "mux4 sel2 failed");
               3: if(y !== d) $fatal(1, "mux4 sel3 failed");
            endcase
        end
        $display("[PASS] mux4 exercise: all selections work");
        $finish;
    end
endmodule
