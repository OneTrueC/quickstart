INC = -I. -I/usr/include
LIB =

CFLAGS = -Wall -Wextra -std=c99 -pedantic $(INC)
LDFLAGS = $(LIB)

PROFFLAGS = -O3
BUILDFLAGS = $(PROFFLAGS) -s
DEBUGFLAGS = -g3

SOURCE = main.c

MAKE = $(CC) $(CFLAGS) $(LDFLAGS) $(SOURCE) -o

all: debug

build: $(SOURCE)
	$(MAKE) $@ $(BUILDFLAGS)
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

debug: $(SOURCE)
	@$(MAKE) $@ $(DEBUGFLAGS)
	@chmod +x $@
	@./$@
	@rm -f $@

gdb: $(SOURCE)
	$(MAKE) $@ $(DEBUGFLAGS)
	chmod +x $@
	gdb ./$@
	rm -f ./$@

strace: $(SOURCE)
	$(MAKE) $@ $(DEBUGFLAGS)
	chmod +x $@
	strace ./$@
	rm -f ./$@

memcheck: $(SOURCE)
	$(MAKE) $@ $(DEBUGFLAGS)
	chmod +x $@
	valgrind --leak-check=full --show-leak-kinds=all ./$@
	rm -f $@

perfprof: $(SOURCE)
	$(MAKE) $@ $(DEBUGFLAGS) $(PROFFLAGS)
	chmod +x $@
	valgrind --tool=callgrind --cache-sim=yes --enable-debuginfod=yes  \
	         --trace-children=yes --dump-instr=yes --collect-jumps=yes \
	         --branch-sim=yes ./$@
	callgrind_annotate --auto=yes callgrind.out*
	rm -f $@

memprof: $(SOURCE)
	$(MAKE) $@ $(DEBUGFLAGS) $(PROFFLAGS)
	chmod +x $@
	valgrind --tool=massif --heap=yes --stacks=yes --threshold=0.0 ./$@
	rm -f $@
