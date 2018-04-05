#include "../../shared/plasmaSoPCDesign.h"
#include "../../shared/plasma.h"

#define MemoryRead(A)     (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) *(volatile unsigned int*)(A)=(V)

#define FREQ_HORLOGE 50000000

void wait( unsigned int ms );

unsigned int my_lfsr(unsigned int lfsr);

unsigned int butt_to_tiret(unsigned int button);

unsigned int time_level(unsigned int score);
