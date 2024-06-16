onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_mem_decrypt/q_data
add wave -noupdate /test_mem_decrypt/clk
add wave -noupdate /test_mem_decrypt/reset
add wave -noupdate /test_mem_decrypt/start
add wave -noupdate -expand -group Outputs /test_mem_decrypt/address
add wave -noupdate -expand -group Outputs /test_mem_decrypt/data
add wave -noupdate -expand -group Outputs /test_mem_decrypt/wen
add wave -noupdate -expand -group Outputs /test_mem_decrypt/memory_sel
add wave -noupdate -expand -group Outputs /test_mem_decrypt/finish
add wave -noupdate -expand -group Outputs /test_mem_decrypt/decrypt_mem_handler
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/i
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/j
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/k
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/temp_i
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/temp_j
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/temp_k
add wave -noupdate -expand -group {Internal Signals} /test_mem_decrypt/DUT/f
add wave -noupdate -expand -group STATE /test_mem_decrypt/DUT/state
add wave -noupdate -expand -group STATE /test_mem_decrypt/DUT/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 294
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
WaveRestoreZoom {0 ps} {108403 ps}
