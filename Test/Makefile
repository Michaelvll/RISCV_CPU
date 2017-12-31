CROSS_COMPILE = riscv32-unknown-elf-

CXX = $(CROSS_COMPILE)g++
CXXFLAGS = -march=rv32i -mabi=ilp32 -c
AS = $(CROSS_COMPILE)as
AS_FLAGS = -march=rv32i -mabi=ilp32
LD = $(CROSS_COMPILE)ld
LD_FLAGS =  -T memory.ld
BIN = $(CROSS_COMPILE)objcopy
DUMP = $(CROSS_COMPILE)objdump
DUMP_FLAGS = -d
ELF = riscv32-unknown-elf

CPP_FILES = $(wildcard *.cpp)
S_FILES = $(wildcard *.[s|S])

STDNAME = inst_rom.mem
PROGRAM = $(if $(CPP_FILES),$(basename $(CPP_FILES)),$(basename $(S_FILES)))

%.mem: %.bin
	python3 ./bin2mem.py $< $@ $(STDNAME)

%.dump: %.om
	$(DUMP) $< $(DUMP_FLAGS)

%.readelf: %.o
	$(ELF) -h $<

%.bin: %.om
	$(BIN) $< -O binary $@

%.om: %.o rom.o %.cpp
	$(LD) $< rom.o -o $@ $(LD_FLAGS)

%.om: %.o %.s
	$(LD) $< -o $@

rom.o:
	$(AS) -o rom.o rom.s $(AS_FLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

%.o: %.s
	$(AS) -o $@ $< $(AS_FLAGS)

%.S: %.cpp
	$(CXX) $(CXXFLAGS) -S -o $@ $<

cleantmp:
	@rm -f *.o *.om *.bin

clean:
	@rm -f *.o *.om *.bin *.mem
	


