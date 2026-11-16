# 同步 FIFO 规格书（Design Specification）v1.0

**项目名称：** `sync_fifo`（单时钟、FWFT / show-ahead）

## 1. 目的与范围

用于 UART TX 待发送数据缓冲。此 FIFO 只有一个 `clk`，不需要 CDC/Gray 码。
第一版采用寄存器数组实现的 **First-Word-Fall-Through**：只要不为空，`rd_data` 组合显示队首数据。
目的：让 UART TX 在 `rd_en` 的同一个上升沿锁存队首，同时 FIFO 更新读指针。

## 2. 参数

- `DATA_WIDTH`: 数据位宽，默认 8，要求 >=1。
- `DEPTH`: 队列容量（不是地址宽度），默认 8，要求 >=2。**必须支持非 2 的幂**（例如 5）。
- 读/写指针位宽 `PTR_W = max(1, $clog2(DEPTH))`。
- 有效数据计数位宽 `COUNT_W = $clog2(DEPTH+1)`，可以表示 0 到 DEPTH。

## 3. 接口和复位

参考 `01_module_interfaces.md` 中 `sync_fifo` 端口声明。
`rst_n` 为异步低有效复位。复位清零 `wr_ptr`, `rd_ptr`, `level`，`empty=1`, `full=0`, `rd_data=0`。
**内存数组不要求复位**：失效数据由 `level=0` 屏蔽；避免无意义的复位资源。

## 4. 读写接受规则（最关键的设计约定）

```
rd_fire = rd_en && !empty;
wr_fire = wr_en && (!full || rd_fire);
```

| FIFO 当前状态 | wr_en | rd_en | 行为 | 下一 level |
|---|---:|---:|---|---|
| 空 | 1 | 0 | 写入 | +1 |
| 空 | 0 | 1 | 忽略读请求 | 不变 |
| 空 | 1 | 1 | **只写入，不旁路读** | +1 |
| 中间 | 1 | 1 | 读一个、写一个 | 不变 |
| 满 | 1 | 0 | 拒绝写入，不覆盖数据 | 不变 |
| 满 | 0 | 1 | 读一个 | -1 |
| 满 | 1 | 1 | **同时接受读写** | 不变 |

特别注意：在满时，同时读写允许写入（即使 `full=1`）；若你的 `wr_fire=wr_en&&!full`，会错误丢掉该写请求。

## 5. 指针和顺序

- 写请求真正接受（`wr_fire=1`）时，`mem[wr_ptr] <= wr_data`，`wr_ptr` 加一并回绕。
- 读请求真正接受（`rd_fire=1`）时，`rd_ptr` 加一并回绕。
- 回绕规则 `if (ptr == DEPTH-1) ptr_next = 0; else ptr_next = ptr+1;`，不能简单依赖二进制溢出（DEPTH=5 会出错）。
- 两个请求都接受时 `level` 不变；仅写加 1、仅读减 1。
- FIFO 必须保持先进先出顺序。

## 6. `rd_data` 数据可见性

- `!empty` 时，`rd_data` 显示 **当前队首** `mem[rd_ptr]`；无需先脉冲 `rd_en`。
- `empty` 时，`rd_data` 固定为 0，不可作为有效数据。
- 在读取上升沿之前，消费方可以采样当前 `rd_data`；时钟沿过后显示新的队首。
- 满时读写可能针对同一个物理存储地址。该时钟沿**之前**消费方拿到旧队首，沿后新数据留在 FIFO 尾部。不同综合存储结构的 read-during-write 特性可能不同；此示范选择组合读寄存器数组，最终 ASIC SRAM 实现需重新确认接口语义。

## 7. 时序设计指导

- 用 `always_ff @(posedge clk or negedge rst_n)` 控制 `wr_ptr`, `rd_ptr`, `level`。
- 组合逻辑可以 `assign full=(level==DEPTH); assign empty=(level==0);`
- `rd_data = empty ? '0 : mem[rd_ptr]`。
- 不需要从输入生成新的时钟；所有状态更新都由同一个 `clk` 驱动。

## 8. 验收条件

- `make fifo` (DEPTH=4) 通过。
- `make fifo5` (DEPTH=5) 通过。
- 满写被阻止，空读被阻止。
- 满时同时读写接受两侧；空时同时读写只接受写。
- 队首顺序正确、level 始终 0..DEPTH、复位标志正确。
- 仿真产生 VCD，检查 `level`, `rd_data`, `wr_en`, `rd_en` 波形。

## 9. 自测题

1. 为什么 `COUNT_W` 不能简单取 `$clog2(DEPTH)`？
2. `DEPTH=5` 时指针宽度是多少？有效状态计数宽度又是多少？
3. 满时同时读写，如何保证数据不被误覆盖？
4. 空时同时读写，如果想旁路接受读，需要在设计里增加什么逻辑？
5. 为什么 FWFT 的 `rd_data` 和寄存器读出型 FIFO 的 `rd_data` 时序不同？
