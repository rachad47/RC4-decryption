onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_memory_handler/address
add wave -noupdate -radix unsigned /test_memory_handler/address_d
add wave -noupdate -radix unsigned /test_memory_handler/address_decrypt
add wave -noupdate -radix unsigned /test_memory_handler/address_init
add wave -noupdate -radix unsigned /test_memory_handler/address_m
add wave -noupdate -radix unsigned /test_memory_handler/address_shuffle
add wave -noupdate -radix unsigned /test_memory_handler/data
add wave -noupdate -radix unsigned /test_memory_handler/data_d
add wave -noupdate -radix unsigned /test_memory_handler/data_decrypt
add wave -noupdate -radix unsigned /test_memory_handler/data_init
add wave -noupdate -radix unsigned /test_memory_handler/data_shuffle
add wave -noupdate -radix unsigned /test_memory_handler/mem_sel_decrypt
add wave -noupdate -radix unsigned /test_memory_handler/mem_sel_init
add wave -noupdate -radix unsigned /test_memory_handler/mem_sel_shuffle
add wave -noupdate -radix unsigned /test_memory_handler/output_data_decrypt
add wave -noupdate -radix unsigned /test_memory_handler/output_data_shuffle
add wave -noupdate -radix unsigned /test_memory_handler/q
add wave -noupdate -radix unsigned /test_memory_handler/q_m
add wave -noupdate -radix unsigned /test_memory_handler/start_decrypt
add wave -noupdate -radix unsigned /test_memory_handler/start_init
add wave -noupdate -radix unsigned /test_memory_handler/start_shuffle
add wave -noupdate -radix unsigned /test_memory_handler/wren
add wave -noupdate -radix unsigned /test_memory_handler/wren_d
add wave -noupdate -radix unsigned /test_memory_handler/wren_decrypt
add wave -noupdate -radix unsigned /test_memory_handler/wren_init
add wave -noupdate -radix unsigned /test_memory_handler/wren_shuffle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 280
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
WaveRestoreZoom {47043 ps} {113314 ps}
