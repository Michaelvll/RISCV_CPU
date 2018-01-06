CROSS_COMPILE = riscv32-unknown-elf-

CXX = $(CROSS_COMPILE)g++
C = $(CROSS_COMPILE)gcc
CXXFLAGS = -march=rv32i -mabi=ilp32 -c -O2
CFLAGS = -march=rv32i -mabi=ilp32 -c -O2
AS = $(CROSS_COMPILE)as
AS_FLAGS = -march=rv32i -mabi=ilp32
LD = $(CROSS_COMPILE)ld
LD_FLAGS =  -T memory.ld -L /opt/riscv/riscv32-unknown-elf/lib/ -L /opt/riscv/lib/gcc/riscv32-unknown-elf/7.2.0/ -lc -lgcc -lm -lnosys
DLD_FLAGS =  -T dmemory.ld -L /opt/riscv/riscv32-unknown-elf/lib/ -L /opt/riscv/lib/gcc/riscv32-unknown-elf/7.2.0/ -lc -lgcc -lm -lnosys
BIN = $(CROSS_COMPILE)objcopy
DUMP = $(CROSS_COMPILE)objdump
DUMP_FLAGS = -d
ELF = riscv32-unknown-elf

CPP_FILES = $(wildcard *.cpp)
S_FILES = $(wildcard *.[s|S])

STDNAME = inst_rom
PROGRAM = $(if $(CPP_FILES),$(basename $(CPP_FILES)),$(basename $(S_FILES)))

%.mem: %.bin
	python3 ./bin2mem.py $< $@ $(STDNAME).mem

%.dump: %.om
	$(DUMP) $< $(DUMP_FLAGS)

%.readelf: %.o
	$(ELF) -h $<

%.dmem: %.dbin
	python3 ./bin2mem.py $< $@ $(STDNAME).mem
%.dbin:%.dom
	$(BIN) $< -O binary $@
	cp $@ $(STDNAME).bin
%.dom: %.o drom.o system.o %.cpp
	$(LD) $< drom.o system.o -o $@ $(DLD_FLAGS) 
%.dom: %.o drom.o system.o %.c
	$(LD) $< drom.o system.o -o $@ $(DLD_FLAGS)

drom.o:
	$(AS) -o drom.o drom.s $(AS_FLAGS)
%.ddump:%.dom
	$(DUMP) $< $(DUMP_FLAGS)


%.bin: %.om
	$(BIN) $< -O binary $@
	cp $@ $(STDNAME).bin

%.om: %.o rom.o system.o %.cpp
	$(LD) $< rom.o system.o -o $@ $(LD_FLAGS)
%.om: %.o rom.o system.o %.c
	$(LD) $< rom.o system.o -o $@ $(LD_FLAGS)

%.om: %.o %.s
	$(LD) $< -o $@

rom.o:
	$(AS) -o rom.o rom.s $(AS_FLAGS)

system.o:
	$(CXX) -o system.o system.c $(CXXFLAGS)

%.o: %.c
	$(C) $(CFLAGS) -o $@ $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<


%.o: %.s
	$(AS) -o $@ $< $(AS_FLAGS)

%.S: %.cpp
	$(CXX) $(CXXFLAGS) -S -o $@ $<

cleantmp:
	@rm -f *.o *.om *.bin 

clean:
	@rm -f *.o *.om *.bin *.mem *.dmem *.dbin *.in *.out *.s
	


