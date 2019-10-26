makedir:
	@echo == MAKEDIR ==
	mkdir -p build

build: makedir
	@echo == BUILD ==
    # Assembler
	riscv32-unknown-elf-as $(PROJECT).s -o build/$(PROJECT).o -march=rv32i
    # Linker
	riscv32-unknown-elf-ld build/$(PROJECT).o -o build/$(PROJECT).om
    # Copy object file to different format (here reverse order of bytes)
	riscv32-unknown-elf-objcopy -O binary build/$(PROJECT).om build/$(PROJECT).bin
	# Convert from binary to text file
	od -An -w4 -t x4 build/$(PROJECT).bin > build/$(PROJECT).hex
	# Add zeros
	cat build/$(PROJECT).hex ../romBlank3072 > build/$(PROJECT).hex
	# Limit numnber of lines, copy one level up
	head -3072 build/$(PROJECT).hex > $(PROJECT).hex
    # Delet build artifacts
	rm -rf build

clean:
	@echo == CLEAN ==
	rm -rf $(PROJECT).hex
	rm -rf build