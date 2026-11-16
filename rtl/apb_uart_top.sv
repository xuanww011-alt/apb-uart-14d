// Day 8/9 TODO: APB -> TX FIFO -> UART TX 最小可交付顶层。
`timescale 1ns/1ps
`default_nettype none
module apb_uart_top #(
    parameter integer FIFO_DEPTH = 8
)(
    input  wire        pclk,
    input  wire        presetn,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [7:0]  paddr,
    input  wire [31:0] pwdata,
    output wire [31:0] prdata,
    output wire        pready,
    output wire        pslverr,
    output wire        uart_txd
);
    // TODO: 实例化 apb_regs、sync_fifo、uart_tx，使用端口名连接。
    // v1 没有 uart_rxd 输入；UART RX 属于第二阶段扩展。
    // FIFO 是 FWFT：队首 rd_data 在读之前有效，可在同一时钟边沿被 UART TX 锁存。
    // pop 条件建议：tx_enable && !tx_busy && !tx_fifo_empty。
    assign prdata   = 32'h00000000;
    assign pready   = 1'b0;
    assign pslverr  = 1'b0;
    assign uart_txd = 1'b1;
endmodule
`default_nettype wire
