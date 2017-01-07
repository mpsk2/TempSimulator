CC=gcc
AS=nasm

ASFLAGS=-felf64
CFLAGS=-Wall -pedantic --std=c11 -g
LFLAGS=-g -Wall

OBJ=data.o sim.o
OBJ_E=$(OBJ) main.o
OBJ_T=$(OBJ) test.o

EXECUTABLE=temp_sim

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ_E)
		gcc $(OBJ_E) $(LFLAGS) -o $(EXECUTABLE)

%.o: %.c
		$(CC) $(CFLAGS) -c $<

%.o: %.asm
		$(AS) $(ASFLAGS) $<	

clean:
		rm -rf *.o $(EXECUTABLE)

