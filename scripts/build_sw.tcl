# scripts/build_sw.tcl  (Vitis 2019.2, run from repo root)
set xsa  [file normalize build/system.xsa]
set inc  [file normalize software/include]
set src  [file normalize software/src]
set app  mmio_ss_test
set proc u_cpu_unit_cpu_i_microblaze_mcs_0_microblaze_I

setws vitis_ws
app create -name $app -hw $xsa -proc $proc -os standalone -lang c++ -template {Empty Application}
importsources -name $app -path $src
app config -name $app -add include-path $inc
app build -name $app

if {![file exists vitis_ws/$app/Debug/$app.elf]} { puts "ERROR: build failed"; exit 1 }
exit 0