SRC = src
BIN = bin
IVERI = iverilog
VERISIM = vvp
WAVE = gtkwave
WAVESPATH = waves

VERIFLAGS = -g2012 -Isrc
SIMFLAGS = 
WAVEFLAGS =

CWD = $(CURDIR)
makefile_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

##### Compilation rules and objects: #####
#__GENMAKE__
BINS = $(BIN)/defines.o \
	$(BIN)/legv8.o \
	$(BIN)/microcode.o \
	$(BIN)/top.o 

$(BIN)/defines.o: $(SRC)/defines.sv
	$(IVERI) -o $@ $(VERIFLAGS) $^

$(BIN)/legv8.o: $(SRC)/legv8.sv
	$(IVERI) -o $@ $(VERIFLAGS) $^

$(BIN)/microcode.o: $(SRC)/microcode.sv
	$(IVERI) -o $@ $(VERIFLAGS) $^

$(BIN)/top.o: $(SRC)/top.sv
	$(IVERI) -o $@ $(VERIFLAGS) $^

#__GENMAKE_END__

##### Main rules:
# Compile:
all: $(BINS)
	@printf "Finished!\n"

# Simulate:
%:
	@cd $(WAVESPATH) && $(VERISIM) $(CWD)/$(BIN)/$(basename $@).o
	
# GTKWave:
w%:
	$(WAVE) $(WAVESPATH)/$(basename $(@:w%=%)).vcd

clean:
	$(RM) $(BIN)/*

clean_waves:
	$(RM) $(WAVESPATH)/*