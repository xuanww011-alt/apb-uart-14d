# 模块接口定义 v0.1（2026-11-12）

## 0. 项目边界

第一版只做 **APB3 风格寄存器写入 → TX FIFO → UART TX**。RX 作为延伸项。
全系统共享 `pclk=50MHz`，低电平复位 `presetn/rst_n`，不引入跨时钟域。
总线数据宽度 32bit，地址宽度 8bit，FIFO 数据宽度 8bit。

```
                +-----------------+
PADDR/PWDATA -->|   apb_regs     |--tx_push/tx_data--+
                | STATUS / CTRL   |                   v
                |  BAUD_DIV       |               sync_fifo
                +-----------------+                   |
                             tx_enable,baud_div        | FWFT rd_data[7:0]
                                 |                    v
                                 +----------------->uart_tx ---> uart_txd
```

## 1. sync_fifo (`rtl/sync_fifo.sv`)

| 端口 | 方向 | 位宽 | 说明 |
|---|---|---|---|
| clk | in | 1 | FIFO 时钟 |
| rst_n | in | 1 | 异步低有效复位 |
| wr_en | in | 1 | 请求写入 |
| wr_data | in | DATA_WIDTH | 输入数据 |
| full | out | 1 | FIFO 满 |
| rd_en | in | 1 | 请求读出 |
| rd_data | out | DATA_WIDTH | FWFT：非空时队首数据 |
| empty | out | 1 | FIFO 空 |
| level | out | $clog2(DEPTH+1) | 当前有效数据数 |

参数：DATA_WIDTH=8，DEPTH=8；测试也覆盖 DEPTH=4、5。

## 2. uart_tx (`rtl/uart_tx.sv`)

| 端口 | 方向 | 位宽 | 说明 |
|---|---|---|---|
| clk, rst_n | in | 1/1 | 时钟/异步低有效复位 |
| start | in | 1 | 非 busy 状态在上升沿采样为 1 即启动 |
| data_in | in | 8 | 待发送字节，启动沿锁存 |
| baud_div | in | 16 | 每个 UART bit 对应的时钟周期数 |
| txd | out | 1 | 串口输出；空闲=1 |
| busy | out | 1 | 正在发送 |
| done | out | 1 | 一帧完成，单周期脉冲 |

- 帧格式 8N1，低位先发；不含奇偶校验。
- 50MHz 时钟、115200bps 近似值：baud_div=434。
- 改写波特率时建议只在空闲时生效；TX 在启动沿锁存当前波特率值。

## 3. apb_regs (`rtl/apb_regs.sv`)

输入 APB：`pclk`, `presetn`, `psel`, `penable`, `pwrite`, `paddr[7:0]`, `pwdata[31:0]`。
输出 APB：`prdata[31:0]`, `pready`, `pslverr`。
FIFO 状态输入：`tx_fifo_full`, `tx_fifo_empty`, `tx_busy`。
控制输出：`tx_push`（成功写 TXDATA 时脉冲）、`tx_data[7:0]`, `baud_div[15:0]`, `tx_enable`。

v1 选择 **零等待 APB**：合法访问的 ACCESS 阶段 `PREADY=1`；非法地址或满 FIFO 写 TXDATA 时 `PSLVERR=1`，**不接受该写入**。无需复杂的 wait-state 逻辑。

## 4. apb_uart_top (`rtl/apb_uart_top.sv`)

接收 APB 信号，输出 `uart_txd`；内部实例化 `apb_regs`、`sync_fifo`、`uart_tx`。

- FIFO 队首数据在 `!empty` 时组合可见（FWFT）。
- 若 `tx_enable && !tx_busy && !tx_fifo_empty`，在同一上升沿使 `fifo.rd_en=1` 与 `uart_tx.start=1`，UART 锁存边沿前的 `rd_data`，FIFO 弹出队首。
- 不要在两个模块之间多加一个无说明的寄存器，否则可能重复或漏发一个字节。

## 5. uart_rx (`rtl/uart_rx.sv`)

仅第二阶段拓展。输入 `rxd, baud_div, clk, rst_n`；输出 `data_out[7:0], valid, framing_error`。
若以后需要 RX，请先补同步输入处理、中心采样、帧错误检查，再添加 RX FIFO/寄存器。
