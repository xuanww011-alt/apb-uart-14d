// Day 1 已完成示例，组合逻辑 8-bit 2:1 mux。
`timescale 1ns/1ps
module mux2 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sel,
    output wire [7:0] y
);
    assign y = sel ? b : a;
endmodule
