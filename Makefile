INC = -I. -I/usr/include
LIB =

CFLAGS = -Wall -Wextra -std=c99 -pedantic $(INC)
LDFLAGS = $(LIB)

PROFFLAGS = -Os
BUILDFLAGS = $(PROFFLAGS) -s
DEBUGFLAGS = -g3

SRC = $(wildcard *.c)

RUNOPTS =

CCOMP = $(CC) $(CFLAGS) $(LDFLAGS) $(SRC) -o

.PHONY: clean profclean build debug gdb strace memcheck perfprof memprof

all: debug

build: $(SRC)
	$(CCOMP) $@ $(BUILDFLAGS)
	chmod +x $@

clean:
	rm -f debug
	rm -f gdb
	rm -f memcheck
	rm -f build
	rm -f strace
	rm -f perfprof
	rm -f memprof

profclean:
	rm -f callgrind.out*
	rm -f massif.out*

debug: $(SRC)
	@$(CCOMP) $@ $(DEBUGFLAGS)
	@chmod +x $@
	@./$@ $(RUNOPTS)
	@rm -f $@

gdb: $(SRC)
	$(CCOMP) $@ $(DEBUGFLAGS)
	chmod +x $@
	gdb ./$@
	rm -f ./$@

strace: $(SRC)
	$(CCOMP) $@ $(DEBUGFLAGS)
	chmod +x $@
	strace -- ./$@ $(RUNOPTS)
	rm -f ./$@

memcheck: $(SRC)
	$(CCOMP) $@ $(DEBUGFLAGS)
	chmod +x $@
	valgrind --leak-check=full --show-leak-kinds=all -s -- ./$@ $(RUNOPTS)
	rm -f $@

perfprof: $(SRC)
	$(CCOMP) $@ $(DEBUGFLAGS) $(PROFFLAGS)
	chmod +x $@
	valgrind --tool=callgrind --cache-sim=yes --enable-debuginfod=yes  \
	         --trace-children=yes --dump-instr=yes --collect-jumps=yes \
	         --branch-sim=yes -- ./$@ $(RUNOPTS)
	callgrind_annotate --auto=yes callgrind.out*
	rm -f $@

memprof: $(SRC)
	$(CCOMP) $@ $(DEBUGFLAGS) $(PROFFLAGS)
	chmod +x $@
	valgrind --tool=massif --heap=yes --stacks=yes --threshold=0.0 .-- /$@ \
	         $(RUNOPTS)
	rm -f $@
