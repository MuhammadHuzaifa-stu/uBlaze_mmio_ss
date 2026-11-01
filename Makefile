SHELL := /bin/bash
VIVADO_ENV ?= source ~/.xilinx_env
VIVADO = $(VIVADO_ENV) && vivado -mode batch -notrace

PRJ   := uBlaze/ublaze_mcs
RUNS  := $(PRJ)/ublaze_mcs.runs
TOP   := mcs_top_vanilla

# Everything the hardware build depends on
HW_SRCS := $(shell sed -n 's|^\./\(.*\.sv\)$$|hardware/\1|p' hardware/flist.f) \
           hardware/flist.f hardware/constraints.xdc \
           $(PRJ)/ublaze_mcs.xpr scripts/build_hw.tcl

SYNTH_DCP := $(RUNS)/synth_1/$(TOP).dcp
IMPL_DCP  := $(RUNS)/impl_1/$(TOP)_routed.dcp
BIT       := $(RUNS)/impl_1/$(TOP).bit

.PHONY: all hw synthesis implementation bitstream gui clean distclean
all hw: bitstream

synthesis:      $(SYNTH_DCP)
implementation: $(IMPL_DCP)
bitstream:      $(BIT)

define vivado_run
	@mkdir -p build
	@$(VIVADO) -log build/vivado_$(1).log -jou build/vivado_$(1).jou \
	    -source scripts/build_hw.tcl -tclargs $(1)
endef

$(SYNTH_DCP): $(HW_SRCS)
	$(call vivado_run,synth)

$(IMPL_DCP): $(SYNTH_DCP)
	$(call vivado_run,impl)

$(BIT): $(IMPL_DCP)
	$(call vivado_run,bitstream)

# Open the project in the Vivado GUI (close any batch job first)
gui:
	@$(VIVADO_ENV) && vivado -mode gui $(PRJ)/ublaze_mcs.xpr &

clean:
	rm -rf build .Xil *.log *.jou

# Also wipes generated Vivado run/cache output (forces a full rebuild)
distclean: clean
	rm -rf $(PRJ)/ublaze_mcs.runs $(PRJ)/ublaze_mcs.cache \
	       $(PRJ)/ublaze_mcs.ip_user_files $(PRJ)/ublaze_mcs.hw $(PRJ)/ublaze_mcs.sim