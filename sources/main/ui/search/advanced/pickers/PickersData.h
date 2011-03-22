
#import <Foundation/Foundation.h>
#import "BundleLookup.h"
#import "Themes.h"

@interface PickersData : NSObject

-(NSDictionary*) locationDictionary;
-(NSDictionary*) categoryDictionary;
-(NSDictionary*) experienceDictionary;
-(NSDictionary*) salaryDictionary;

/** Init the place, category, and experience dictionaries from the plist. */
-(void) initDictionaries;

@end
