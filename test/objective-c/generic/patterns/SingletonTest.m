
#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <SenTestingKit/SenTestingKit.h>


@interface SingletonTest : SenTestCase {
}
- (void) testSharedInstance;
@end


@implementation SingletonTest

- (void) testSharedInstance {
    Singleton *a = [Singleton sharedInstance];
    Singleton *b = [Singleton sharedInstance];
	STAssertEquals(a, b, @"Singleton returned different instances.");
}

@end
