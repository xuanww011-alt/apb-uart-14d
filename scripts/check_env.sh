#!/usr/bin/env bash
set -uo pipefail
required=(bash make iverilog vvp)
optional=(git gtkwave verilator yosys)
missing=0
printf '%s\n' '=== APB-UART 环境检查 ==='
for t in "${required[@]}"; do
  if command -v "$t" >/dev/null 2>&1; then
    printf '[OK]       %-12s %s\n' "$t" "$(command -v "$t")"
  else
    printf '[MISSING]  %-12s 请安装后再运行 make smoke\n' "$t"
    missing=1
  fi
done
for t in "${optional[@]}"; do
  if command -v "$t" >/dev/null 2>&1; then
    printf '[OK]       %-12s %s\n' "$t" "$(command -v "$t")"
  else
    printf '[OPTIONAL] %-12s 当前未安装，不妨碍 Day 1 的 make smoke\n' "$t"
  fi
done
if (( missing )); then
  printf '%s\n' '环境检查未通过：安装 sudo apt install -y iverilog make 再试。'
  exit 1
fi
printf '%s\n' '[PASS] 基本工具存在。下一步：make smoke'
