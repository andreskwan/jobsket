
#import "NSValue+valueWithImages.h"

@implementation NSValue (valueWithImages)

+(NSValue*) valueWithImages:(enum Images) images {
    return [NSValue value: &images withObjCType: @encode(enum Images)];
}

@end