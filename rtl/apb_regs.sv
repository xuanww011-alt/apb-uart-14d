// Day 8 TODO: APB3 风格寄存器块（PREADY/PSLVERR）。
// 地址/错误响应规则见 docs/03_apb_register_map.md。
`timescale 1ns/1ps
`default_nettype none
module apb_regs (
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
    output wire        tx_push,       // APB TXDATA 写成功时仅高 1clk
    output wire [7:0]  tx_data,
    input  wire        tx_fifo_full,
    input  wire        tx_fifo_empty,
    input  wire        tx_busy,
    output wire [15:0] baud_div,
    output wire        tx_enable
);
    // TODO: 地址译码、寄存器读写、错误响应。
    assign prdata    = 32'h00000000;
    assign pready    = 1'b0;    // TODO（v1 规范要求无等待访问）
    assign pslverr   = 1'b0;
    assign tx_push   = 1'b0;
    assign tx_data   = 8'h00;
    assign baud_div  = 16'd434;
    assign tx_enable = 1'b0;
endmodule
`default_nettype wire
