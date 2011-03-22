
#import "NSMutableDictionary+objectForImages.h"


@implementation NSMutableDictionary (objectForImages)

-(void) setObject:(id)anObject forImages:(enum Images)key {
    [self setObject: anObject forKey:[NSValue valueWithImages:key]];
}

-(id) objectForImages:(enum Images)key {
    return [self objectForKey:[NSValue valueWithImages:key]];
}

@end
