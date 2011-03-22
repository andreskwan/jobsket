
#import "SynthesizeSingleton.h"

@interface Localization : NSObject {
    NSBundle* fallbackBundle;
    NSBundle* preferredBundle;
}

- (NSString*) localizedStringForKey:(NSString*)key;


+ (Localization*) sharedLocalization;

@end
