# Day 1：执行单（建议 3.5～4.5 小时）

目标：**确认本地仿真链路 + 理解模块接口 + 完成基础题 + 一次 Git 提交**。

## 任务（按照顺序）

- [ ] 0:00～0:45 在 Windows 配好 WSL2 + Ubuntu（已经有 WSL 的直接跳过）。
- [ ] 0:45～1:00 安装 Icarus Verilog、GTKWave、Make、Git，并打开 VS Code WSL 工作区。
- [ ] 1:00～1:20 运行 `bash scripts/check_env.sh`、`make smoke`、`make parse`。
- [ ] 1:20～1:50 阅读 `docs/01_module_interfaces.md` 和 `docs/02_fifo_spec.md`，手画结构图。
- [ ] 1:50～2:50 完成 `docs/05_hdlbits_day1.md` 的 12 道基础题。
- [ ] 2:50～3:20 修改 `examples/mux4_exercise.sv`，运行 `make mux4` 直到 PASS。
- [ ] 3:20～3:45 用自己的话写清 APB/FIFO/UART 数据路径，并回答下方 5 道题。
- [ ] 3:45～4:00 Git 初始化与首次提交。

## 今日要能解释的架构（v1 TX-only）

APB Master → APB 寄存器块 → TX FIFO → UART TX FSM → uart_txd

UART 发送 8N1：1 个 start=0 + 8 个数据位（LSB first）+ 1 个 stop=1。

## 5 道口述题（先自己回答，查资料再修正）

1. 为什么描述硬件时不应该把连续赋值理解成 C 语言的顺序执行？
2. `wire [7:0] a` 和 `wire [0:7] a` 分别有几位？
3. Verilog 的位运算 `&` 和逻辑运算 `&&` 有什么不同？
4. 模块实例化按名称连接、按位置连接，各有什么风险？
5. 一个深度 8 的 FIFO，如何确定数据、指针、计数器的位宽？

## Day 1 交付物

- 有可重复执行的 `make smoke` 通过记录。
- `build/tb_mux2.vcd` 出现（波形工具如可打开更好）。
- `make mux4` 通过（扩展练习）。
- HDLBits 12 道题完成；将卡壳原因填入 `logs/day1_progress.csv`。
- 有一次 Git 提交，建议消息：`day1: setup simulator and read specs`。

**正常现象**：`make fifo` 初始失败，直到后续真正实现 FIFO。
