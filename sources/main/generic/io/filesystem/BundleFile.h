
#import <Foundation/Foundation.h>
#import "BundleLookup.h"
#import "File.h"

/** This class doesn't have write methods because it would break code signing. */
@interface BundleFile : File {
}

-(NSDictionary*) dictionaryFromPlist;

@end
