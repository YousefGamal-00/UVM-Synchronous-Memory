# Invoke it using : vsim -c -do run.do

vlib work
vlog -f src_file.list +cover

# onfinish to stop the simultion not ending as we need to write cover report inside questa before quit -f 
vsim top -coverage \
    -voptargs=+acc \
    -onfinish stop \
    +UVM_VERBOSITY=UVM_LOW \
    -classdebug \
    -uvmcontrol=all \
    -sv_seed random

coverage save MEM.ucdb -onexit -du MEM

run -all

coverage report -detail -cvg -comments -output FC_cov_rprt.txt

quit -sim

# Detailed UCDB coverage, including annotated information
vcover report MEM.ucdb -details -annotate -all -output CC_SVA_cov_rprt.txt

# Combined coverage: assertions + directives + functional + code
vcover report MEM.ucdb \
               -du=MEM \
               -recursive \
               -assert \
               -directive \
               -cvg \
               -codeAll \
               -output Summary_Report.txt

# quit -f