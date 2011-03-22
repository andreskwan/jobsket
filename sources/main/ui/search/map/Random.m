
#import "Random.h"

@implementation Random

static unsigned long seed;


void initRandomSeed(long firstSeed) { 
    seed = firstSeed;
}


float nextRandomFloat() {
    return (((seed= 1664525*seed + 1013904223)>>16) / (float)0x10000);
}


- (id) init {
    self = [super init];
    if (self != nil){
        initRandomSeed( (long) [[NSDate date] timeIntervalSince1970] );
    }
    return self;
}


@end
