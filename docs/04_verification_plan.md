# 验证计划（Testplan）v0.1

## P0（必须）

| ID | 模块 | 激励/场景 | 检查点 | 预计完成 |
|---|---|---|---|---|
| FIFO-01 | FIFO | 复位 | empty=1, full=0, level=0, rd_data=0 | Day 3/6 |
| FIFO-02 | FIFO | 连续写入 DEPTH 个数据 | level=DEPTH，满标志正确 | Day 6 |
| FIFO-03 | FIFO | 满时仅写请求 | 拒绝覆盖 | Day 6 |
| FIFO-04 | FIFO | 满时同沿读+写 | 两侧被接受且顺序正确 | Day 6 |
| FIFO-05 | FIFO | 空时同沿读+写 | 只接受写，无旁路 | Day 6 |
| FIFO-06 | FIFO | DEPTH=5 指针回绕 | 无数据丢失/重复 | Day 6 |
| TX-01 | UART TX | 启动发送 8'hA5 | 8N1、低位先发、bit 周期正确 | Day 7/9 |
| TX-02 | UART TX | 空闲、复位 | TXD=1，busy/done 合理 | Day 7/9 |
| APB-01 | APB | SETUP→ACCESS 正常写 | 只在有效 ACCESS 更新 | Day 8/9 |
| APB-02 | APB | 读取 STATUS | 与 FIFO 和 UART 实际状态一致 | Day 8/9 |
| APB-03 | APB | FIFO 满时写 TXDATA | PSLVERR=1，无数据覆盖 | Day 8/9 |
| SYS-01 | TOP | APB 连续写入多字节 | UART 按顺序发出，无漏发/重复 | Day 9/11 |

## P1（建议）

- 不同 BAUD_DIV（例如 2、3、434）下帧时序检查。
- TX_ENABLE 清零后，新启动被禁止，已经在发送的帧正常完成。
- 复位发生在 UART 正在发送时，返回 IDLE / TXD=1。
- 添加简单参考队列和 Scoreboard，自动对比 APB 写入与 UART 输出字节。
- 随机产生 APB 数据，约束写入成功，收集数据模式覆盖率（0x00/0xFF/随机）。

## 证据文件

- 仿真命令与工具版本。
- PASS/FAIL 日志。
- 关键波形截图。
- 测试覆盖表（说明未覆盖项）。
- 修复过的真实 bug：现象→原因→修复→回归。

只有实测过的数据可以写进简历。
