// Day 1 扩展练习：8-bit 4:1 mux。
// TODO：仅修改 assign y 这一行，使用 sel 选择 a/b/c/d。
// 期望：00 -> a, 01 -> b, 10 -> c, 11 -> d。
`timescale 1ns/1ps
module mux4_exercise (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    input  wire [1:0] sel,
    output logic [7:0] y
);
    always_comb begin
        case(sel)
            2'b00: y=a;
            2'b01: y=b;
            2'b10: y=c;
            2'b11: y=d;

            default: y=8'h00;
        endcase
    end
endmodule
