# HDLBits Day 1：必做 12 题 + 选做 3 题

入口：https://hdlbits.01xz.net/wiki/Problem_sets

每做完一题，在日志中记录：`题目、是否一次过、卡壳原因、修改点`。不要直接打开 Show solution。

## 必做（按顺序）

1. Getting Started — https://hdlbits.01xz.net/wiki/Step_one
2. Output Zero — https://hdlbits.01xz.net/wiki/Zero
3. Simple wire — https://hdlbits.01xz.net/wiki/Wire
4. Four wires — https://hdlbits.01xz.net/wiki/Wire4
5. Inverter — https://hdlbits.01xz.net/wiki/Notgate
6. AND gate — https://hdlbits.01xz.net/wiki/Andgate
7. NOR gate — https://hdlbits.01xz.net/wiki/Norgate
8. XNOR gate — https://hdlbits.01xz.net/wiki/Xnorgate
9. Declaring wires — https://hdlbits.01xz.net/wiki/Wire_decl
10. Vectors — https://hdlbits.01xz.net/wiki/Vector0
11. Vectors in more detail — https://hdlbits.01xz.net/wiki/Vector1
12. Vector part select — https://hdlbits.01xz.net/wiki/Vector2

## 选做（如果还有 20～30 分钟）

13. Bitwise operators — https://hdlbits.01xz.net/wiki/Vectorgates
14. Modules — https://hdlbits.01xz.net/wiki/Module
15. Connecting ports by name — https://hdlbits.01xz.net/wiki/Module_name

## 用自己的话写 4 条笔记

- `assign` 是持续驱动硬件连线，不是 C/C++ 的一次性赋值。
- `wire [7:0]` 有 8 位，`wire [0:7]` 也有 8 位，但索引方向不同。
- `{a,b}` 是拼接，不是集合；`a[7:0]` 是位切片。
- `&`/`|` 和 `&&`/`||` 对于多位向量输出宽度/语义不同。

第二天再集中学习 `always_comb`、`if`、`case`，今天不要跳到 FSM。
