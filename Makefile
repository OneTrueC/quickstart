INC = -I. -I/usr/include
LIB =

CFLAGS = -Wall -Wextra -std=c99 -pedantic $(INC)
LDFLAGS = $(LIB)

BUILDFLAGS = -O3 -s
DEBUGFLAGS = -g3

SOURCE = main.c

MAKE = $(CC) $(CFLAGS) $(LDFLAGS) $(SOURCE) -o

all: debug

build: $(SOURCE)
	$(MAKE) $@ $(BUILDFLAGS)
	chmod +x $@

clean:
	rm -f debug
	rm -f memcheck
	rm -f build
	rm -f perfcheck

perfclean:
	rm -f callgrind.out*

debug: $(SOURCE)
	@$(MAKE) $@ $(DEBUGFLAGS)
	@chmod +x $@
	@./$@
	@rm -f $@

memcheck: $(SOURCE)
	$(MAKE) $@ $(DEBUGFLAGS)
	chmod +x $@
	valgrind --leak-check=full ./$@
	rm -f $@

perfcheck: $(SOURCE)
	$(MAKE) $@ -O3 $(DEBUGFLAGS)
	chmod +x $@
	valgrind --tool=callgrind --cache-sim=yes --enable-debuginfod=yes --trace-children=yes --dump-instr=yes --collect-jumps=yes --branch-sim=yes --callgrind-out-file=callgrind.out.fme  ./$@
	callgrind_annotate --auto=yes callgrind.out*
