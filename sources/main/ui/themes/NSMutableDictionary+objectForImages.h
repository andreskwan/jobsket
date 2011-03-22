
#import <Foundation/Foundation.h>
#import "ImagesEnum.h"
#import "NSValue+valueWithImages.h"

/** 
 * This and NSValue+valueWithImages helps to use enum with dictionaries
 * without having to wrap the enum.
 */
@interface NSMutableDictionary (objectForImages)

-(void) setObject:(id)anObject forImages:(enum Images)key;

-(id) objectForImages:(enum Images)key;

@end
