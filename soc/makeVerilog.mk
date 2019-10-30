makedir:
	@echo == MAKEDIR ==
	mkdir -p build

compile: makedir
	@echo == COMPILE ==
	iverilog -g2005 -D SIMULATION=$(SIMULATION_STEPS) -o build/$(PROJECT).vvp $(SOURCE)

simulate: compile
	@echo == SIMULATE ==
	vvp build/$(PROJECT).vvp

synthesize: makedir
	@echo == SYNTHESIZE ==
	yosys -q -l build/$(PROJECT).log -p 'synth_ice40 -top $(PROJECT) -blif build/$(PROJECT).blif' $(SOURCE)
	arachne-pnr -q -d 5k -P sg48 -o build/$(PROJECT).asc -p $(PROJECT).pcf build/$(PROJECT).blif
	icepack build/$(PROJECT).asc build/$(PROJECT).bin

resources: makedir
	@echo == SYNTHESIZE ==
	yosys -q -l build/$(PROJECT).log -p 'synth_ice40 -top $(PROJECT) -blif build/$(PROJECT).blif' $(SOURCE)
	@rm -rf build/$(PROJECT).resources
	arachne-pnr -d 5k -P sg48 -o build/$(PROJECT).asc -p $(PROJECT).pcf build/$(PROJECT).blif 2>&1 | tee -a build/$(PROJECT).resources
	@echo == Timing ==
	icetime -d up5k -mtr build/$(PROJECT).timing build/$(PROJECT).asc
	@echo == Report ==
	@grep --color=always -B 0 -A 22 "After packing:"  build/$(PROJECT).resources
	@grep --color=always "Total path delay:" build/$(PROJECT).timing

clean:
	@echo == CLEAN ==
	rm -rf build
