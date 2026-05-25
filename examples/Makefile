# Part of smax-clib
#
# Build exammple programs
#
# Author: Attila Kovacs

ifdef XCHANGE
  CPPFLAGS += -I$(XCHANGE)/include
  LDFLAGS += -L$(XCHANGE)/lib
endif

ifdef REDISX
  CPPFLAGS += -I$(REDISX)/include
  LDFLAGS += -L$(REDISX)/lib
endif

LDFLAGS += $(THREADS) $(NETFLAGS)

ifeq ($(OSNAME), Linux)
  LDFLAGS += -lrt
endif

# Top level make targets...
all:  $(BIN)/scalar $(BIN)/array $(BIN)/multidim $(BIN)/simpleScalar $(BIN)/simpleArray

# Additional dependencies...
$(BIN)/scalar: $(OBJ)/scalar.o $(SMAX) 

$(BIN)/array: $(OBJ)/array.o $(SMAX) 

$(BIN)/multidim: $(OBJ)/multidim.o $(SMAX) 

$(BIN)/simpleScalar: $(OBJ)/simpleScalar.o $(SMAX) 

$(BIN)/simpleArray: $(OBJ)/simpleArray.o $(SMAX) 


# Standard generic rules and targets...
include $(GLOBALINC)/recipes.mk