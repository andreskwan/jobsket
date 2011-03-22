#import "Localization.h"

@implementation Localization

SYNTHESIZE_SINGLETON_FOR_CLASS(Localization);


- (id)init {
	@synchronized(self) {
        if ((self = [super init])) {
            debug(@"Checking bundles...");
        
            // note: there is no reason to change the fallback language
            NSString *fallbackLanguage = @"en";
            
            // set the fallback bundle
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:fallbackLanguage];
            fallbackBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
            debug(@"    Fallback bundle for \"%@\"... %@", fallbackLanguage, fallbackBundle==nil ? @"NOT FOUND" : @"FOUND");
            
            // set the preferred bundle
            NSString *preferredLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
            bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:preferredLanguage];
            preferredBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
            debug(@"    Preferred bundle for \"%@\"... %@", preferredLanguage, preferredBundle==nil ? @"NOT FOUND" : @"FOUND");
            
        }
		return self;
	}
}


/**
 * Return the value from the preferred bundle, or from the fallback bundle, or return the key itself.
 */
- (NSString*) localizedStringForKey:(NSString*)key {
    
    // try preferred bundle
    NSString* result = nil;
    
    if (preferredBundle!=nil) {
        //debug(@"looking key %@ on the preferredBundle: %@ \n%@", key, [preferredBundle localizedStringForKey:key value:nil table:nil], preferredBundle);
        result = [preferredBundle localizedStringForKey:key value:nil table:nil];
    }
    
    // if the value is missing, use the fallback bundle
    if (result == nil) {
        //debug(@"looking key %@ on the fallbackBundle: %@ \n%@", key, [fallbackBundle localizedStringForKey:key value:nil table:nil], fallbackBundle);
        result = [fallbackBundle localizedStringForKey:key value:nil table:nil];
    }
    
    // if the value is missing, just return the key
    if (result == nil) {
        result = key;
    }
    
    return result;
}


@end
