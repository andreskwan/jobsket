
#import "Singleton.h"
#import "DebugLog.h"

/* Be aware: if you subclass, the synchronize(self) will act on two different selfs,
 * which in extreme rare cases could result in assigning twice to uniqueInstance.
 * Note that there is no way to prevent subclassing in Cocoa.
 */

@implementation Singleton

// set value to [Singleton sharedInstance] if you want an eager Singleton
static id uniqueInstance = nil;


+ (id)sharedInstance {
	@synchronized(self) {
        if (uniqueInstance == nil) {
            [[self alloc] init]; // this calls allocWithZone
        }
	}
    return uniqueInstance;
}
							 

// called by [self alloc] 
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (uniqueInstance == nil) {
            uniqueInstance = [super allocWithZone:zone];
            return uniqueInstance;  // assignment and return on first allocation
        } else {
            warn(@"Attempt to allocate twice, returning nil");
        }
    }
    return nil; // returns nil after the first allocation
}


// a copy attempt will return the unique instance
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)init {
	// synchronize any code that alters shared state
	@synchronized(self) {
		[super init];	
		// class initialization stuff if any
		return self;
	}
}


#pragma mark protect from deallocation

// don't increment the retain count
- (id)retain {
    return self;
}


// don't return zero
- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}


// don't decrement the retain count
- (void)release {
}


// don't add to an autorelease pool
- (id)autorelease {
    return self;
}


@end
