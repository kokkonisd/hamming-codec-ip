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


# Source HDL files
SOURCES = $(patsubst src/%.vhdl, %, $(wildcard src/*.vhdl))


all: $(SOURCES)


%: src/%.vhdl tb/%_tb.vhdl
	@echo ""
	@echo "\033[0;33m[Compiling \`$@.vhdl\` & \`$@_tb.vhdl\` ...]\033[0m"
	$(GHDL) -s src/$@.vhdl tb/$@_tb.vhdl
	$(GHDL) -a src/$@.vhdl tb/$@_tb.vhdl
	$(GHDL) -e $@_tb

	@echo "\033[0;33m[Running simulation of \`$@_tb\` ...]\033[0m"
	$(GHDL) -r $@_tb --vcd=simu/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) && \
		echo "\033[0;32m[\`$@\` PASS]\033[0m" || (echo "\033[0;31m[\`$@\` FAIL]\033[0m"; exit $(ERROREXIT))
	
	@echo ""


clean:
	rm -rf *.cf simu/*.vcd *_tb *.o


.PHONY: all clean
