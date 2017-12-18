PROGRAM = inst_test

CXX = riscv32-unknown-elf-g++
CXX_FLAGS = -O2
SXX = riscv32-unknown-elf-as
LD = riscv32-unknown-elf-ld
BIN = riscv32-unknown-elf-objcopy

CPP_FILES = $(wildcard *.cpp)
S_FILES = $(wildcard *.[s|S])

cpp: Cpp Bin
s: S Bin

Cpp:
	$(CXX) -o $(PROGRAM).o $(CPP_FILES) $(CXX_FLAGS)

S:
	$(SXX) $(S_FILES) -o $(PROGRAM).o -march=rv32i

Bin:
	$(LD) $(PROGRAM).o -o $(PROGRAM).om
	$(BIN) $(PROGRAM).om -O binary $(PROGRAM).bin


clean:
	@rm -f *.o *.om *.bin
	


