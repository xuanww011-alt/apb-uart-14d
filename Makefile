SHELL := /bin/bash
IVERILOG ?= iverilog
VVP ?= vvp
BUILD := build
RTL := $(wildcard rtl/*.sv)

.PHONY: all env smoke parse mux4 fifo fifo5 wave fifo-wave clean

all: smoke parse

env:
	bash scripts/check_env.sh

$(BUILD):
	mkdir -p $(BUILD)

smoke: | $(BUILD)
	$(IVERILOG) -g2012 -Wall -s tb_mux2 -o $(BUILD)/tb_mux2.vvp examples/mux2.sv tb/tb_mux2.sv
	$(VVP) $(BUILD)/tb_mux2.vvp

parse:
	$(IVERILOG) -g2012 -Wall -tnull -s apb_uart_top $(RTL)
	@echo '[PASS] RTL interface skeleton parses (NOT a functionality test)'

mux4: | $(BUILD)
	$(IVERILOG) -g2012 -Wall -s tb_mux4_exercise -o $(BUILD)/tb_mux4.vvp examples/mux4_exercise.sv tb/tb_mux4_exercise.sv
	$(VVP) $(BUILD)/tb_mux4.vvp

fifo: | $(BUILD)
	$(IVERILOG) -g2012 -Wall -s tb_sync_fifo -o $(BUILD)/tb_sync_fifo.vvp rtl/sync_fifo.sv tb/tb_sync_fifo.sv
	$(VVP) $(BUILD)/tb_sync_fifo.vvp

fifo5: | $(BUILD)
	$(IVERILOG) -g2012 -Wall -s tb_sync_fifo -Ptb_sync_fifo.DEPTH=5 -o $(BUILD)/tb_sync_fifo.vvp rtl/sync_fifo.sv tb/tb_sync_fifo.sv
	$(VVP) $(BUILD)/tb_sync_fifo.vvp

wave:
	gtkwave $(BUILD)/tb_mux2.vcd

fifo-wave:
	gtkwave $(BUILD)/tb_sync_fifo.vcd

clean:
	rm -rf $(BUILD)
