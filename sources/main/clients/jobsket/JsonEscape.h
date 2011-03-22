
#import <Foundation/Foundation.h>

@interface JsonEscape : NSObject {
    NSDictionary *htmlEntities;
}

@property(nonatomic,retain) NSDictionary *htmlEntities;


/** 
 * Replace HTML entities, drop invalid characters, 
 * and escape: double quote and left slash.
 */
-(NSString*) replaceEntitiesAndEscape:(NSString*) unsafeText;


/** Replace HTML entities. */
-(NSString*) replaceEntities:(NSString*) unsafeText;


/** Escape double quote and left slash. */
-(NSString*) escape:(NSString*)unsafeText;


@end
