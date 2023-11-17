GHDL=ghdl 
VERS="--std=08"
FLAG="--ieee=synopsys"

all:
	ghdl -a and2.vhd and2_testbench.vhd
	ghdl -e and2_testbench
	ghdl -r and2_testbench --wave=wave=and2.ghw --stop-time=1us