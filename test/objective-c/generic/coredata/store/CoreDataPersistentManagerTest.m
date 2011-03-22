
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CoreDataTesting.h"
#import "CoreDataPersistentManager.h"


@interface CoreDataPersistentManagerTest : SenTestCase {
@private
	CoreDataTesting *_coreDataTesting;
}
@property(nonatomic, retain) CoreDataTesting *coreDataTesting;
@end


@implementation CoreDataPersistentManagerTest

@synthesize coreDataTesting=_coreDataTesting;

- (void) test1Entities {
	STAssertTrue([[self coreDataTesting] test1Entities],@"There are no entities.");
}

- (void) test1Singleton {
	STAssertTrue([[self coreDataTesting] test2Singleton],@"Two returned context are not the same.");
}

- (void) test2RemoveAll {
	STAssertTrue([[self coreDataTesting] test3RemoveAll], @"Not all instances were removed.");
}

- (void) test3Create {
	STAssertTrue([[self coreDataTesting] test4Create], @"There sould be 10 jobs.");
}

- (void) test4KVC {
	STAssertTrue([[self coreDataTesting] test5KVC], @"Title shouldn't be nil.");
}

- (void) setUp {
	if (!self.coreDataTesting){
        self.coreDataTesting = [CoreDataTesting new];
	}
	if (!self.coreDataTesting.manager){
		self.coreDataTesting.manager = [CoreDataPersistentManager sharedInstance];
	}
}

@end
