
#import "NSString+Extension.h"

@implementation NSString (Extension)


/** 
 * Count occurences of the string 'needle' in the string 'haystack'.
 */
-(NSUInteger) occurrencesOfString:(NSString *)needle {
    const char *rawNeedle = [needle UTF8String];
    NSUInteger needleLength = strlen(rawNeedle);
    const char *rawHaystack = [self UTF8String];
    NSUInteger haystackLength = strlen(rawHaystack);
    NSUInteger needleCount = 0;
    NSUInteger needleIndex = 0;
    for (NSUInteger index = 0; index < haystackLength; ++index) {
        const char thisCharacter = rawHaystack[index];
        if (thisCharacter != rawNeedle[needleIndex]) {
            needleIndex = 0; // they don't match; reset the needle index
        }
        //resetting the needle might be the beginning of another match
        if (thisCharacter == rawNeedle[needleIndex]) {
            needleIndex++; // char match
            if (needleIndex >= needleLength) {
                needleCount++; // we completed finding the needle
                needleIndex = 0;
            }
        }
    }
    return needleCount;
}


@end
