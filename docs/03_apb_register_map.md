# APB-UART v1 寄存器映射与总线约定

## APB 配置

- 只支持单时钟 `PCLK=50MHz`、32bit PWDATA/PRDATA、8bit 字节地址。
- 访问仅允许 32bit 对齐地址；`PSEL & PENABLE` 表示 ACCESS 阶段。
- `PREADY=1`：本教学版不添加等待周期。
- 合法地址、合法操作 `PSLVERR=0`；非法地址、禁止操作或 TX 满时写 TXDATA `PSLVERR=1`。
- 只有 `PSEL && PENABLE && PREADY` 成立的 ACCESS 时钟沿才真正更新写寄存器；SETUP 不写。

## 寄存器

| 地址（字节偏移） | 名称 | R/W | 位定义 | 上电/复位值 |
|---|---|---|---|---|
| `0x00` | TXDATA | W | `[7:0]` 数据；其他位忽略。满时拒绝写并报错 | 无存储型寄存器 |
| `0x04` | STATUS | R | bit0 TX_EMPTY；bit1 TX_FULL；bit2 TX_BUSY；bit3 TX_ENABLE；其余保留 0 | 取决于实时状态 |
| `0x08` | BAUD_DIV | R/W | `[15:0]` 每 UART 位的 PCLK 数；0 为非法配置 | 434 |
| `0x0C` | CTRL | R/W | bit0 TX_ENABLE；其他位保留 0 | 1 |

## 数据流

1. APB Master 先 SETUP（`PSEL=1, PENABLE=0`）；再 ACCESS（`PSEL=1, PENABLE=1`）。
2. ACCESS 写 TXDATA 且 FIFO 不满时，`tx_push=1` 写入 TX FIFO。
3. TX_ENABLE=1、UART 空闲且 FIFO 非空时，UART 在下一可用上升沿接受队首。
4. UART 根据 BAUD_DIV 生成起始位、8 数据位、停止位。
5. 如 FIFO 满，TXDATA 写入返回 `PSLVERR=1`，该字节不入 FIFO。

## 设计约束

- `PREADY=1` 且无等待的 v1 实现不能验证 APB wait-state 延长；可作为后续扩展任务。
- 不必在两周内做 UART RX，更不要将未实现的 RX 写入简历成果。
