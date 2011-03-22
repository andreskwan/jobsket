
#import "NSMutableArray+Category.h"

@implementation NSMutableArray (Category)

/**
 * Shuffle the elements of the array.
 *
 * This is a naive shuffle, should be http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
 * Read http://www.robweir.com/blog/2010/02/microsoft-random-browser-ballot.html
 */
- (void)shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(NSString*) description {
	NSMutableString *string = [[NSMutableString alloc] initWithCapacity:1];
	[string appendFormat:@"NSMutableArray with %d elements",[self count]];
	for (NSUInteger i = 0; i < [self count]; i++) {
		id object = [self objectAtIndex:i];
		if ([object respondsToSelector:@selector(shortDescribe)]) {
	  	    [string appendFormat:@"\n%d = %@", i, [object performSelector:@selector(shortDescribe)]];	
		} else {
			[string appendFormat:@"\n%d = %@", i, [object description]];	
		}

		
	}
	[string appendFormat:@"\n"];
	return string;
}


@end
