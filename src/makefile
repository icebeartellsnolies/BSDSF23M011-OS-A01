
CC := gcc
CFLAGS := -Wall -Wextra -g -I../include
BIN := ../bin
SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

all: $(BIN)/client

$(BIN):
	mkdir -p $(BIN)

$(BIN)/client: $(OBJS) | $(BIN)
	$(CC) $(CFLAGS) $(OBJS) -o $(BIN)/client

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
