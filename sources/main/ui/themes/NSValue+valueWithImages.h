
#import <Foundation/Foundation.h>
#import "ImagesEnum.h"

/** 
 * This and NSMutableDictionary+objectForImages helps to use enum with dictionaries
 * without having to wrap the enum.
 */
@interface NSValue (valueWithImages)

+(NSValue*) valueWithImages:(enum Images)images; 

@end
