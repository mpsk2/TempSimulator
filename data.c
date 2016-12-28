#include <stdlib.h>
#include <stdio.h>
#include "data.h"

data_t* data_init(int64_t width, int64_t height) {
	data_t* result = (data_t*) malloc(sizeof(data_t));
	result->fields = (float*) malloc(sizeof(float) * width * height);
	result->warmers = (float*) malloc(sizeof(float) * width);
	result->coolers = (float*) malloc(sizeof(float) * height);
	result->width = width;
	result->height = height;
	return result;
}

void data_print_fields(data_t* d) {
	for (int i = 0; i < d->height; i++) {
		for (int j = 0; j < d->width; j++) {
			printf("%12.6f ", d->fields[i * d->width + j]);
		}
		printf("\n");
	}
}

void data_print(data_t* d) {
	printf("Data:\nWidth:  %" PRId64 "\nHeight: %" PRId64 "\nFields:\n", d->width, d->height);
	data_print_fields(d);
	printf("Warmers:\n");
	for (int i = 0; i < d->width; i++) {
		printf("%12.6f ", d->warmers[i]);
	}
	printf("\nCoolers:\n");
	for (int i = 0; i < d->height; i++) {
		printf("%12.6f ", d->coolers[i]); 
	}
	printf("\n");
}

data_t* data_file_read(char* filename) {
	FILE* file = fopen(filename, "r");
	if (!file) {
		fprintf(stderr, "File does not exists");
		exit(1);
	}
	int64_t width, height;
	fscanf(file, "%" PRId64 " %" PRId64 "", &width, &height);
	data_t* result = data_init(width, height);
	for (int i = 0; i < height; i++) {
		for (int j = 0; j < width; j++) {
			fscanf(file, "%f", &result->fields[i*width + j]);
		}
	}
	for (int i = 0; i < width; i++) {
		fscanf(file, "%f", &result->warmers[i]);
	}
	for (int i = 0; i < height; i++) {
		fscanf(file, "%f", &result->coolers[i]);
	}
	return result;
}
