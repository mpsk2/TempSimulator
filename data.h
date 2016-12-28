#ifndef __DATA_H__
#define __DATA_H__

#include <inttypes.h>

typedef struct data {
	int64_t width;
	int64_t height;
	float* fields;
	float* warmers;
	float* coolers;
} data_t;

data_t* data_init(int64_t, int64_t);
void data_print_fields(data_t*);
void data_print(data_t*);
data_t* data_file_read(char*);

#endif
