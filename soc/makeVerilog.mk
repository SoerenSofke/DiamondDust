makedir:
	@echo == MAKEDIR ==
	mkdir -p build

compile: makedir
	@echo == COMPILE ==
	iverilog -D SIMULATION=$(SIM_STEPS) -o build/$(PROJECT).vvp $(SOURCE)

simulate: compile
	@echo == SIMULATE ==
	vvp build/$(PROJECT).vvp

synthesize: makedir
	@echo == SYNTHESIZE ==
	yosys -q -l build/$(PROJECT).log -p 'synth_ice40 -top $(PROJECT) -blif build/$(PROJECT).blif' $(SOURCE)
	arachne-pnr -q -d 5k -P sg48 -o build/$(PROJECT).asc -p $(PROJECT).pcf build/$(PROJECT).blif
	icepack build/$(PROJECT).asc build/$(PROJECT).bin

clean:
	@echo == CLEAN ==
	rm -rf build
