INC = -I. -I/usr/include
LIB = 

CFLAGS = -Wall -Wextra -std=c99 -pedantic $(INC)
LDFLAGS = -s $(LIB)

SOURCE = main.c

MAKE = $(CC) $(CFLAGS) $(LDFLAGS) $(SOURCE) -o

all: debug

build: $(SOURCE)
	$(MAKE) $@
	chmod +x $@

clean:
	rm -f debug
	rm -f memcheck
	rm -f build

debug: $(SOURCE)
	@$(MAKE) $@
	@chmod +x $@
	@./$@
	@rm -f $@

memcheck: $(SOURCE)
	$(MAKE) $@
	chmod +x $@
	valgrind --leak-check=full ./$@
	rm -f $@
