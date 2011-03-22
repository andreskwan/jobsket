
#import <Foundation/Foundation.h>


@interface BundleLookup : NSObject {
}


/**
 * Returns the NSBundle for the current target.
 *
 * To retrieve the bundle of a target we call [NSBundle bundleWithIdentifier:bundleId]
 * where bundleId is the "Bundle identifier" set in the plist of the target.
 *
 * Since we have no way of knowing on which target this file is running on,
 * we try the bundle identifiers of the targets on this project.
 * This means you have to add an identifier here manually for each target you add to the project.
 */
+(NSBundle*) getBundle;


@end
