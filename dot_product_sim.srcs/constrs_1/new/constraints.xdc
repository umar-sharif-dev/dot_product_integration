# Define input clock period (in nanoseconds)
# 200 MHz = 5 ns period

create_clock -name clk -period 5.000 [get_ports clk]
