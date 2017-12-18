PROGRAM = inst_test

CROSS_COMPILE = riscv32-unknown-elf-

CXX = $(CROSS_COMPILE)g++
CXX_FLAGS = -O2
SXX = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
BIN = $(CROSS_COMPILE)objcopy
DUMP = $(CROSS_COMPILE)objdump
DUMP_FLAGS = -d
ELF = riscv32-unknown-elf

CPP_FILES = $(wildcard *.cpp)
S_FILES = $(wildcard *.[s|S])

ct: Cpp Bin Trasf
st: S Bin Transf
c: ct cleantmp
s: st cleantmp
dump:
	$(DUMP) $(PROGRAM).om $(DUMP_FLAGS)
readelf:
	$(ELF) -h $(PROGRAM).o

Cpp:
	$(CXX) -o $(PROGRAM).o $(CPP_FILES) $(CXX_FLAGS)

S:
	$(SXX) $(S_FILES) -o $(PROGRAM).o -march=rv32i

Bin:
	$(LD) $(PROGRAM).o -o $(PROGRAM).om
	$(BIN) $(PROGRAM).om -O binary $(PROGRAM).bin

Transf:
	python3 ./bin2mem.py $(PROGRAM).bin $(PROGRAM).mem

cleantmp:
	@rm -f *.o *.om *.bin	

clean:
	@rm -f *.o *.om *.bin *.mem
	


