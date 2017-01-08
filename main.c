#include <stdio.h>
#include <stdlib.h>
#include "data.h"
#include "sim.h"

void validate_entry(int);

int main(int argc, char** argv) {
	switch (argc) {
		case 1:
			fprintf(stderr, "Filename not provided\n");
		case 2:
			fprintf(stderr, "Weight not provided\n");
		case 3:
			fprintf(stderr, "Steps number not provided\n");
			exit(1);
			break;
	}
	char* filename = argv[1];
	float weight = atof(argv[2]);
	int steps = atoi(argv[3]);
	data_t* d = data_file_read(filename);
	data_print_fields(d);
	data_start(d, weight);
	while (steps) {
		int c;
		do {
			c = getchar();
		} while(c != '\n') ;
		step();
		data_print_fields(d);
		steps--;
	}
	return 0;
}