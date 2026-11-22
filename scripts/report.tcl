# -----------------------
# Area            : FPGA "area" means the utilization numbers: LUTs, flip-flops, BRAM and DSP. 
#                   The percentages are in the "Utilization" column.
# Power           : it's a vectorless estimate that assumes default toggle rates, so treat it 
#                   as rough. Look at the "Confidence level" line in the report. Accuracy 
#                   improves with a SAIF file from simulation.
# Interactive use : to run commands one by one, use vivado -mode tcl, then open_checkpoint <dcp> 
#                   and any report_* command.
# CDC report      : after adding your synchronizers, report_cdc is a good check that the reset, 
#                   sw and uart_rx crossings show as safe. It will also flag the unsynchronized 
#                   miso and sda paths, which is expected for now.
# -----------------------

open_checkpoint uBlaze/ublaze_mcs/ublaze_mcs.runs/impl_1/mcs_top_vanilla_routed.dcp
file mkdir build/reports
report_utilization -hierarchical -file build/reports/utilization.rpt
report_power                     -file build/reports/power.rpt
report_timing_summary -max_paths 10 -file build/reports/timing.rpt
report_clock_utilization         -file build/reports/clocks.rpt
report_cdc                       -file build/reports/cdc.rpt
report_methodology               -file build/reports/methodology.rpt
report_drc                       -file build/reports/drc.rpt
exit