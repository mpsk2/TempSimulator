#include <assert.h>
#include <stdio.h>
#include "sim.h"
#include "data.h"

#define GREEN   "\033[32m"      /* Green */
#define RED     "\033[31m"      /* Red */
#define RESET   "\033[0m"

void print_output(int result, int number) {
	if (result) {
		printf ("[" GREEN " OK " RESET "] TEST %d\n", number);
	} else {
		printf ("[" RED "FAIL" RESET "] TEST %d\n", number);
	}
}

void test1() {
	data_t* d = data_init(3, 4);
	data_start(d, 5);
	int result = 1;
	result &= get_width() == 3;
	result &= get_height() == 4;
	result &= get_fields() == d->fields;
	result &= get_warmers() == d->warmers;
	result &= get_coolers() == d->coolers;
	result &= get_weight() == 5 ;	
	print_output(result, 1);
}

int main(int argc, char** argv) {
	test1();
	return 0;
}
