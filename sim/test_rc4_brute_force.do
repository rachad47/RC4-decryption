onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_rc4_brute_force/clk
add wave -noupdate /test_rc4_brute_force/core_count
add wave -noupdate /test_rc4_brute_force/counter
add wave -noupdate /test_rc4_brute_force/finish_decrypt
add wave -noupdate /test_rc4_brute_force/init_val
add wave -noupdate /test_rc4_brute_force/reset_pulse
add wave -noupdate /test_rc4_brute_force/rst
add wave -noupdate /test_rc4_brute_force/solved
add wave -noupdate /test_rc4_brute_force/solved_counter
add wave -noupdate /test_rc4_brute_force/stop_all
add wave -noupdate /test_rc4_brute_force/valid
add wave -noupdate /test_rc4_brute_force/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 281
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {986 ps}
