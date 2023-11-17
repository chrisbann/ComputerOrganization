GHDL=ghdl 
VERS="--std=08"
FLAG="--ieee=synopsys"

all:
	ghdl -a mux5.vhd mux5_tb.vhd mux64.vhd mux64_tb.vhd shiftleft2.vhd shiftleft2_tb.vhd signextend.vhd signextend_tb.vhd
	ghdl -e mux5_tb
	ghdl -e mux64_tb 
	ghdl -e shiftleft2_tb 
	ghdl -e signextend_tb
	ghdl -r mux5_tb --wave=wave=mux5.ghw --stop-time=1us
	ghdl -r mux64_tb --wave=wave=mux64.ghw --stop-time=1us
	ghdl -r shiftleft2_tb --wave=wave=shiftleft2.ghw --stop-time=1us
	ghdl -r signextend_tb --wave=wave=signextend.ghw --stop-time=1us

mux5:
	ghdl -a mux5.vhd mux5_tb.vhd
	ghdl -e mux5_tb 
	ghdl -r mux5_tb --wave=wave=mux5.ghw --stop-time=1us

mux64:
	ghdl -a mux64.vhd mux64_tb.vhd
	ghdl -e mux64_tb 
	ghdl -r mux64_tb --wave=wave=mux64.ghw --stop-time=1us

signextend:
	ghdl -a signextend.vhd signextend_tb.vhd
	ghdl -e signextend_tb 
	ghdl -r signextend_tb --wave=wave=signextend.ghw --stop-time=1us

shiftleft2:
	ghdl -a shiftleft2.vhd shiftleft2_tb.vhd
	ghdl -e shiftleft2_tb 
	ghdl -r shiftleft2_tb --wave=wave=shiftleft2.ghw --stop-time=1us

