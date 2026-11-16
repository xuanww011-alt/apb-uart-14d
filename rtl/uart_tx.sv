// Day 7 TODO: UART 发送模块，8N1、低位先发、配置波特率分频。
`timescale 1ns/1ps
`default_nettype none
module uart_tx (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,         // !busy 时采样高电平：启动发送
    input  wire [7:0]  data_in,
    input  wire [15:0] baud_div,      // 每个串行 bit 占多少个 clk 周期（>=1）
    output wire        txd,           // 空闲/复位时为高电平
    output wire        busy,
    output wire        done           // 发送完一帧后 1 clk 脉冲
);
    // TODO: IDLE -> START -> DATA -> STOP -> IDLE
    assign txd  = 1'b1;
    assign busy = 1'b0;
    assign done = 1'b0;
endmodule
`default_nettype wire
