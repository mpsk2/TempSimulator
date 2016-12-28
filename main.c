#include <stdio.h>
#include <stdlib.h>
#include "data.h"

int main(int argc, char** argv) {
	if (argc < 2) {
		fprintf(stderr, "Filename not provided\n");
		exit(1);
	}
	data_t* d = data_file_read(argv[1]);
	data_print(d);
	return 0;
}
