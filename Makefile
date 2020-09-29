# HDL compiler
GHDL = ghdl
# Wave simulator
WAVE = gtkwave
# Simulation time
SIMTIME ?= 100ns
# Maximum tolerance assertion level (errors will be triggered for this error type & above)
ASSERTLVL ?= warning
# Flag to indicate if an error should be produced on simulation fail
ERROREXIT ?= 0
# Source code directory
SRC = src
# Test bench directory
TB = tb
# Simulation file directory
SIMU = simu

# Source HDL files
SOURCES = $(patsubst $(SRC)/%.vhdl, %, $(wildcard $(SRC)/*.vhdl))


all: $(SOURCES)


%: $(SRC)/%.vhdl $(TB)/%_tb.vhdl
	@echo ""
	@echo "\033[0;33m[Compiling \`$@.vhdl\` & \`$@_tb.vhdl\` ...]\033[0m"
	$(GHDL) -s $(SRC)/$@.vhdl $(TB)/$@_tb.vhdl
	$(GHDL) -a $(SRC)/$@.vhdl $(TB)/$@_tb.vhdl
	$(GHDL) -e $@_tb

	@echo "\033[0;33m[Running simulation of \`$@_tb\` ...]\033[0m"
	$(GHDL) -r $@_tb --vcd=$(SIMU)/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) && \
		echo "\033[0;32m[\`$@\` PASS]\033[0m" || (echo "\033[0;31m[\`$@\` FAIL]\033[0m"; exit $(ERROREXIT))
	
	@echo ""


clean:
	rm -rf *.cf $(SIMU)/*.vcd *_tb *.o


.PHONY: all clean
