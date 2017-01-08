#ifndef __SIM_H__
#define __SIM_H__

#include <inttypes.h>

void start(int64_t width, int64_t height, float* fields, float* warmers, float* coolers, float weight);
void step();

#endif
