#ifndef __SIM_H__
#define __SIM_H__

#include <inttypes.h>

void start(int64_t width, int64_t height, float* fields, float* warmers, float* coolers, float weight);
void step();

int64_t get_width();
int64_t get_height();
float* get_fields();
float* get_warmers();
float* get_coolers();
float get_weight();

#endif
