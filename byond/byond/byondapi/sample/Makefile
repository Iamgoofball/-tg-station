# Change this to point to wherever libbyond.so is stored from your BYOND installation.
BYOND_PATH = ~/.byond/bin

CC = gcc
CPP = g++
CFLAGS = -m32 -pthread -g -Wall -Wno-deprecated -O3 -fno-strict-aliasing
LDFLAGS = -m32 -shared $(BYOND_PATH)/libbyond.so
RM = rm -f
TARGET_LIB = byondapi_sample.so

OBJS = \
	main.o \
	byondapi_cpp_wrappers.o

.PHONY: all
all: ${TARGET_LIB}

$(TARGET_LIB): $(OBJS)
	$(CC) ${LDFLAGS} -o $@ $^

.cpp.o:
	$(CPP) $(CPPFLAGS) $(CFLAGS) -c $*.cpp -o $*.o
.c.o:
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $*.c -o $*.o

.PHONY: clean
clean:
	-${RM} ${TARGET_LIB} ${OBJS}
