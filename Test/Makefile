CROSS_COMPILE = riscv32-unknown-elf-

CXX = $(CROSS_COMPILE)g++
CXX_FLAGS = -O2 -s
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
BIN = $(CROSS_COMPILE)objcopy
DUMP = $(CROSS_COMPILE)objdump
DUMP_FLAGS = -d
ELF = riscv32-unknown-elf

CPP_FILES = $(wildcard *.cpp)
S_FILES = $(wildcard *.[s|S])

STDNAME = inst_rom.mem
PROGRAM = $(if $(CPP_FILES),$(basename $(CPP_FILES)),$(basename $(S_FILES)))

%.mem: %.bin cleantmp
	python3 ./bin2mem.py $< $@
	cp $@ ./$(STDNAME) -f

%.dump: %.om
	$(DUMP) $< $(DUMP_FLAGS)

%.readelf: %.o
	$(ELF) -h $<

%.bin: %.om
	$(BIN) $< -O binary $@

%.om: %.o
	$(LD) $< -o $@

%.o: %.s
	$(AS) -o $@ $< -march=rv32i

%.s: %.cpp
	$(CXX) -o $@ $< $(CXX_FLAGS)

cleantmp:
	@rm -f *.o *.om *.bin	

clean:
	@rm -f *.o *.om *.bin *.mem
	


