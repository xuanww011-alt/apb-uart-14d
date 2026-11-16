// Day 3/6 TODO: 实现满足 docs/02_fifo_spec.md 的同步 FIFO。
// 注意：以下默认赋值只是为了接口骨架可被解析；功能测试应失败。
`timescale 1ns/1ps
`default_nettype none
module sync_fifo #(
    parameter integer DATA_WIDTH = 8,
    parameter integer DEPTH = 8
)(
    input  wire                             clk,
    input  wire                             rst_n,
    input  wire                             wr_en,
    input  wire [DATA_WIDTH-1:0]            wr_data,
    output wire                             full,
    input  wire                             rd_en,
    output wire [DATA_WIDTH-1:0]            rd_data,
    output wire                             empty,
    output wire [$clog2(DEPTH+1)-1:0]       level
);
    // TODO: wr_ptr, rd_ptr, count, mem; 参照 spec 定义 wr_fire/rd_fire。
    // TODO: FWFT：非空时 rd_data 显示队首，空时输出 0。
    // TODO: 支持满时同时读写；空时同周期写+读，只接受写入。
    assign full    = 1'b0;    // TODO - 仅用于接口占位
    assign empty   = 1'b1;    // TODO - 仅用于接口占位
    assign rd_data = {DATA_WIDTH{1'b0}};
    assign level   = '0;
endmodule
`default_nettype wire
