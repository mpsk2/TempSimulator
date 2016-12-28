#include <stdio.h>
#include <stdlib.h>
#include "data.h"
#include "sim.h"

int main(int argc, char** argv) {
	if (argc < 2) {
		fprintf(stderr, "Filename not provided\n");
		exit(1);
	}
	data_t* d = data_file_read(argv[1]);
	data_print(d);
	data_start(d, 5);
	float* s = get_second();
	for (int i = 0; i < 3 * 4; i++) {
		s[i] = i + 0.001 * i;
	}
	printf("%f %f\n", s[0], s[11]);
	step();
	printf("%f %f\n", s[0], s[11]);
	data_print(d);
	return 0;
}
