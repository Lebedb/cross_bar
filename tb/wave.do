onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/clk_i
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/reset_i
add wave -noupdate -color Gold -radix binary /tb_cross_bar/top_cross_bar_inst/req_i
add wave -noupdate -color Gold -radix binary /tb_cross_bar/top_cross_bar_inst/cmd_i
add wave -noupdate -color Gold /tb_cross_bar/top_cross_bar_inst/addr_i
add wave -noupdate -color Gold /tb_cross_bar/top_cross_bar_inst/wdata_i
add wave -noupdate -color Gold -radix binary /tb_cross_bar/top_cross_bar_inst/ack_o
add wave -noupdate -color Gold -radix binary /tb_cross_bar/top_cross_bar_inst/resp_i
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/cross_bar_inst/host_word_o
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/cross_bar_inst/agent_word_i
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/rdata_o
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/cross_bar_inst/rdata_mem
add wave -noupdate -radix binary /tb_cross_bar/top_cross_bar_inst/cross_bar_inst/ack_i
add wave -noupdate -radix unsigned /tb_cross_bar/top_cross_bar_inst/cross_bar_inst/state_cnt
add wave -noupdate /tb_cross_bar/top_cross_bar_inst/cross_bar_inst/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {123 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {1654 ns}
