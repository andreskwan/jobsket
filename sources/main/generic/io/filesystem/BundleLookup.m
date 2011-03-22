
#import "BundleLookup.h"

@implementation BundleLookup


+(NSBundle*) getBundle {
	NSBundle *bundle = nil;
	NSArray *identifiers = [NSArray arrayWithObjects: 
							@"es.com.jano.Jobsket",
							@"es.com.jano.Jobsket3",
							@"es.com.jano.package.coredata",
							@"es.com.jano.package.clients",
							@"es.com.jano.package.generic",
							@"es.com.jano.singleTest",
							@"es.com.jano.GHUnit",
							nil];
	for(NSString *bundleId in identifiers) {
		bundle = [NSBundle bundleWithIdentifier:bundleId];
		if (bundle!=nil) break;
	}
	
	// try main bundle
	if ((bundle==nil)) bundle = [NSBundle mainBundle];
	//debug(@"    Bundle id: %@", [bundle bundleIdentifier]);
	
	// abort
	assert(bundle!=nil && "Missing bundle. Check the Bundle identifier on the plist \
		   of this target vs the identifiers array on this class.");
	
	return bundle;
}


@end
