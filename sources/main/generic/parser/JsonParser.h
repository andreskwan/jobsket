
#import <Foundation/Foundation.h>
#import "JSONKit.h"


@interface JsonParser : NSObject {
}

/** Returns a NSDictionary with the JSON in the given NSData. */
+(NSDictionary*) parseJson:(NSString*)jsonString;

@end
