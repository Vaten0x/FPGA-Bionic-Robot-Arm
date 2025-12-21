create_clock -name CLOCK_50 -period 20.000 [get_ports CLOCK_50]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty

set_input_delay -clock CLOCK_50 -max 2 [all_inputs]
set_input_delay -clock CLOCK_50 -min 0 [all_inputs]
set_output_delay -clock CLOCK_50 -max 2 [all_outputs]
set_output_delay -clock CLOCK_50 -min 0 [all_outputs]

set_false_path -from [get_ports KEY0]
set_false_path -from [get_ports KEY1]
set_false_path -from [get_ports SW[*]]