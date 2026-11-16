// 第二阶段可选：v1 TX-only 不要求实现 UART RX。
// 本文件供后续双向收发拓展时使用。
`timescale 1ns/1ps
`default_nettype none
module uart_rx (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        rxd,
    input  wire [15:0] baud_div,
    output wire [7:0]  data_out,
    output wire        valid,
    output wire        framing_error
);
    // TODO: 起始位中心采样、8 个数据位、停止位检查。
    assign data_out      = 8'h00;
    assign valid         = 1'b0;
    assign framing_error = 1'b0;
endmodule
`default_nettype wire
