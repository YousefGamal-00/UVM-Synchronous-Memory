#==============================================================================
# ModelSim/QuestaSim Waveform Configuration
# MEM Testbench Signal Display Setup
#==============================================================================

onerror {resume}

#==============================================================================
# Radix Definitions
#==============================================================================
radix define WR_RD_1B {
    "1'b1" "WRITE",
    "1'b0" "READ",
    -default default
}

#==============================================================================
# Waveform Setup
#==============================================================================
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 20 <NULL>

#==============================================================================
# Top-Level Signals
#==============================================================================
add wave -noupdate /top/mem_if/clk
add wave -noupdate /top/mem_if/rst

#==============================================================================
# Inputs
#==============================================================================
add wave -noupdate -height 20 -expand -group Inputs -radix WR_RD_1B     /top/mem_if/wr_rd_n
add wave -noupdate -height 20 -expand -group Inputs -radix hexadecimal  /top/mem_if/Address
add wave -noupdate -height 20 -expand -group Inputs -radix hexadecimal  /top/mem_if/Data_in
add wave -noupdate -divider <NULL>

#==============================================================================
# Outputs
#==============================================================================
add wave -noupdate -height 20 -expand -group Outputs -radix hexadecimal  /top/mem_if/data_out
add wave -noupdate -height 20 -expand -group Outputs                     /top/mem_if/Valid_out
add wave -noupdate -divider <NULL>

#==============================================================================
# DUT
#==============================================================================
add wave -noupdate -divider -height 25 DUT

add wave -noupdate -height 20 -group DUT -radix hexadecimal  /top/DUT/mem
add wave -noupdate -height 20 -group DUT -radix hexadecimal  /top/DUT/data_out_reg
add wave -noupdate -height 20 -group DUT                      /top/DUT/Valid_out_reg

#==============================================================================
# UVM Class Data — env / scoreboard / agent
# NOTE: class member visibility requires class debug to be enabled at compile/
# optimize time (Questa: `vopt +acc` / `-classdebug`).
#==============================================================================
add wave -noupdate -divider -height 25 Environment

#------------------------------------------------------------------------------
# MEM_scoreboard (env_h.sb) — reference model + running match/mismatch tally
#------------------------------------------------------------------------------
add wave -noupdate -height 20 -expand -group Environment -expand -group Scoreboard -radix hexadecimal  /uvm_root/uvm_test_top/env_h/sb/mem_model
add wave -noupdate -height 20 -expand -group Environment -expand -group Scoreboard -radix hexadecimal  /uvm_root/uvm_test_top/env_h/sb/data_out_ref
add wave -noupdate -height 20 -expand -group Environment -expand -group Scoreboard                      /uvm_root/uvm_test_top/env_h/sb/Valid_out_ref

#------------------------------------------------------------------------------
# MEM_monitor (env_h.agt_h.mon_h) — last transaction sampled, expanded field-by-field
#------------------------------------------------------------------------------
add wave -noupdate -height 20 -expand -group Environment -expand -group Agent -radix hexadecimal \
    -childformat {
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.super      -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.rst        -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.wr_rd_n    -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.Data_in    -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.Address    -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.data_out   -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.Valid_out  -radix hexadecimal}
        {/uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.type_name  -radix hexadecimal}
    } \
    -expand \
    -subitemconfig {
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.super      {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.rst        {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.wr_rd_n    {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.Data_in    {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.Address    {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.data_out   {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.Valid_out  {-radix hexadecimal}
        /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item.type_name  {-radix hexadecimal}
    } \
    /uvm_root/uvm_test_top/env_h/agt_h/mon_h/seq_item

add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>

#==============================================================================
# Wave Configuration
#==============================================================================
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6716 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 203
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {32353 ps}
