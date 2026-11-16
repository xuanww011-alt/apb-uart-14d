# APB-UART 数字 IC 设计 + 验证：14 天冲刺项目

> Day 1 starter（2026-11-12）。这是 **学习用骨架**，不是完成的 UART IP。
> `make smoke` 应通过（用于验环境）；`make fifo` 在你完成 `rtl/sync_fifo.sv` 前 **应失败**（用于驱动后续实现）。
> `make parse` 只检查接口骨架能否解析，不表示功能正确。

## 第一眼看目录

```text
apb-uart-14d/
├── README.md                     # 入口说明
├── Makefile                      # 统一运行入口
├── .gitignore
├── .vscode/extensions.json       # VS Code + WSL 扩展建议
├── docs/
│   ├── 00_day1_tasks.md           # 当天时间表和交付物
│   ├── 01_module_interfaces.md    # 模块接口定义
│   ├── 02_fifo_spec.md            # FIFO 行为规格书（先读）
│   ├── 03_apb_register_map.md     # APB 寄存器映射与协议选择
│   ├── 04_verification_plan.md    # 测试计划
│   └── 05_hdlbits_day1.md         # 第一批题目 + 直达链接
├── rtl/
│   ├── sync_fifo.sv               # 【待实现】同步 FIFO
│   ├── uart_tx.sv                 # 【待实现】UART 发送端
│   ├── apb_regs.sv                # 【待实现】APB 寄存器块
│   ├── apb_uart_top.sv            # 【待实现】项目顶层
│   └── uart_rx.sv                 # 【第二阶段可选】接收端
├── examples/
│   ├── mux2.sv                   # 已实现：Day 1 小例子
│   └── mux4_exercise.sv          # 你来实现：Day 1 扩展练习
├── tb/
│   ├── tb_mux2.sv                # 已实现的环境冒烟测试
│   ├── tb_mux4_exercise.sv       # 扩展练习的自检
│   └── tb_sync_fifo.sv           # FIFO 规格驱动测试（Day 3/6）
├── scripts/check_env.sh         # 工具版本检测
├── logs/day1_progress.csv        # 记录做题和进度
└── build/                       # 仿真输出（git 不跟踪）
```

## Windows + WSL2 + Ubuntu（推荐环境）

**在 Windows 管理员 PowerShell 执行：**

```powershell
wsl --install
```

按提示重启，启动 Ubuntu，首次创建 Linux 用户和密码（密码输入时不会显示字符）。

**以下都在 Ubuntu / WSL 终端执行，不是在 PowerShell 执行：**

```bash
sudo apt update
sudo apt install -y iverilog gtkwave make git unzip
# 第二阶段再装：
sudo apt install -y verilator yosys
```

先把 ZIP 放到 Windows 下载文件夹，然后在 Ubuntu 中运行：

```bash
mkdir -p ~/projects
cd ~/projects
# 替换为实际的 Windows 用户名，或使用 /mnt/c/Users/.../Downloads
unzip /mnt/c/Users/<Windows用户名>/Downloads/apb-uart-day1-starter.zip
cd apb-uart-14d
bash scripts/check_env.sh
make smoke
make parse
```

首次成功输出应包含 `[PASS] mux2 smoke test`。`make smoke` 会在 `build/` 生成 VCD 波形。

```bash
gtkwave build/tb_mux2.vcd
```

> 如果 GTKWave GUI 无法打开，在 VS Code WSL 终端检查 WSLg 图形支持；也可先只完成 `make smoke`，查看日志，稍后处理波形界面。

安装 Windows 版 Visual Studio Code 和 **WSL** 扩展，在 Ubuntu 项目目录运行 `code .`，用 VS Code 打开项目。项目建议存放在 `~/projects`，而不是直接在 `/mnt/c` 下开发，以提升 WSL 文件操作体验。

## 常用命令

| 命令 | 当前预期 | 含义 |
|---|---|---|
| `bash scripts/check_env.sh` | 通过 | 检查基础工具，选装工具缺失仅提示 |
| `make smoke` | **PASS** | 独立的 2:1 mux 冒烟测试 |
| `make parse` | 编译无错 | 仅检查 `rtl/` 顶层接口骨架语法 |
| `make mux4` | **最初 FAIL** | 完成 `examples/mux4_exercise.sv` 后 PASS |
| `make fifo` | **最初 FAIL** | 实现同步 FIFO 后应 PASS |
| `make fifo5` | **最初 FAIL** | 参数深度为 5 的额外测试 |
| `make wave` | 打开波形 | 打开 mux2 VCD |
| `make clean` | 删除构建输出 | 清理 build |

## 项目范围（主动控制 14 天投入）

- **最小可交付 v1：** 8N1 UART TX + 同步 FIFO + APB 从设备 + 自检 Testbench + README/波形/报告。
- **第二阶段可选：** UART RX + RX FIFO、UVM、更加完整的覆盖率、AXI/CDC/异步 FIFO。
- **不承诺：** ASIC 流片、物理实现、真实工艺 PPA、覆盖率 100%。

## 本项目演进规则

1. Day 1：环境、文档、练习，不用提前实现全部 RTL。
2. Day 2～3：组合逻辑/时序逻辑；完善 `sync_fifo.sv` 基本结构。
3. Day 4～6：实现 FIFO、状态边界并跑通 `make fifo` 和 `make fifo5`。
4. Day 7：实现 UART TX。
5. Day 8：实现 APB 寄存器与顶层连接。
6. Day 9：联调完整 TX 数据路径。
7. Day 10～12：SV 自检、Scoreboard、断言、综合/时序基础。
8. Day 13～14：项目总结、简历双版本、投递与面试。

通过标准以 **运行过的测试结果** 为准，不以文件是否存在为准。
