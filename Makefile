SHELL := /bin/bash
VIVADO_ENV ?= source ~/.xilinx_env # sources both vivado and vitis
VIVADO = $(VIVADO_ENV) && vivado -mode batch -notrace

PRJ   := uBlaze/ublaze_mcs
RUNS  := $(PRJ)/ublaze_mcs.runs
TOP   := mcs_top_vanilla
WS    := vitis_ws
APP   := mmio_ss_test

# ---- hardware
HW_SRCS := $(shell sed -n 's|^\./\(.*\.sv\)$$|hardware/\1|p' hardware/flist.f) \
           hardware/flist.f hardware/constraints.xdc \
           scripts/build_hw.tcl

SYNTH_DCP := $(RUNS)/synth_1/$(TOP).dcp
IMPL_DCP  := $(RUNS)/impl_1/$(TOP)_routed.dcp
BIT       := build/$(TOP).bit
MMI       := build/$(TOP).mmi
XSA       := build/system.xsa

# ---- software
SW_SRCS := $(shell find software -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -o -name '*.S' \))
ELF     := $(WS)/$(APP)/Debug/$(APP).elf
DL_BIT  := build/download.bit

.PHONY: all hw synthesis implementation bitstream software download program gui clean distclean
all hw: bitstream

synthesis:      $(SYNTH_DCP)
implementation: $(IMPL_DCP)
bitstream:      $(BIT) $(XSA)
software:       $(ELF)
download:       $(DL_BIT)

define vivado_run
	@mkdir -p build
	@$(VIVADO) -log build/vivado_$(1).log -jou build/vivado_$(1).jou \
	    -source scripts/build_hw.tcl -tclargs $(1)
endef

$(SYNTH_DCP): $(HW_SRCS)
	$(call vivado_run,synth)

$(IMPL_DCP): $(SYNTH_DCP)
	$(call vivado_run,impl)

# One Vivado run produces .bit, .mmi and .xsa in build/
$(BIT): $(HW_SRCS)
	$(call vivado_run,bitstream)

# If only the XSA is missing, force the bitstream step to run again
$(XSA): $(BIT)
	@test -f $@ || { rm -f $(BIT); $(MAKE) --no-print-directory $(BIT); }

# ---- Vitis: platform + app from the XSA (workspace is rebuilt each time)
$(ELF): $(XSA) $(SW_SRCS) scripts/build_sw.tcl
	@rm -rf $(WS)
	@mkdir -p build
	@set -o pipefail; $(VIVADO_ENV) && xsct scripts/build_sw.tcl 2>&1 | tee build/vitis_sw.log

# ---- merge ELF into the bitstream
$(DL_BIT): $(BIT) $(ELF)
	@PROC=$$(grep -o 'InstPath="[^"]*"' $(MMI) | head -1 | cut -d'"' -f2); \
	 echo "Processor instance: $$PROC"; \
	 $(VIVADO_ENV) && updatemem -meminfo $(MMI) -data $(ELF) -bit $(BIT) \
	     -proc $$PROC -out $@ -force

# ---- program the board over JTAG
program: $(DL_BIT)
	@$(VIVADO_ENV) && vivado -mode batch -notrace -log build/program.log -jou build/program.jou \
	    -source scripts/program.tcl -tclargs $(DL_BIT)

# Open the project in the Vivado GUI (close any batch job first)
gui:
	@$(VIVADO_ENV) && vivado -mode gui $(PRJ)/ublaze_mcs.xpr &

clean:
	rm -rf build $(WS) .Xil *.log *.jou

# Also wipes generated Vivado run/cache output (forces a full rebuild)
distclean: clean
	rm -rf $(PRJ)/ublaze_mcs.runs $(PRJ)/ublaze_mcs.cache \
	       $(PRJ)/ublaze_mcs.ip_user_files $(PRJ)/ublaze_mcs.hw $(PRJ)/ublaze_mcs.sim