CC=gcc
AS=nasm

ASFLAGS=-felf64
CFLAGS=-Wall -pedantic --std=c11 -g
LFLAGS=-g -Wall

OBJ=main.o data.o

EXECUTABLE=temp_sim

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ)
		gcc $(OBJ) $(LFLAGS) -o $(EXECUTABLE)

%.o: %.c
		$(CC) $(CFLAGS) -c $<

%.o: %.asm
		$(AS) $(ASFLAGS) $<	

clean:
		rm -rf *.o $(EXECUTABLE)

