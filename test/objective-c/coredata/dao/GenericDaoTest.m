
#import "GenericDaoTest.h"


@implementation GenericDaoTest

@synthesize dao, block, manager, moClass;


- (void) setUpWithDao:(Class)theDao andMo:(Class)theMoClass {
	self.manager = [CoreDataPersistentManager sharedInstance];
	self.dao = [[theDao alloc] initWithManager:manager];
	self.moClass = theMoClass;
}


- (void) setUp {
	if ([self class]==[GenericDaoTest class]) {
		return;
	} else {
		// throw exception if this method is not overriden
	    [NSException raise:NSInternalInconsistencyException
		    		format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];
	}
}


/*
// EXAMPLE SETUP:
 
- (void) setUp {
    if (!dao){
        dao = [[CompanyDao alloc] initWithManager:manager];
        moClass = [CompanyMo class];
        [self setBlock:^(void){
            return [dao performSelector:@selector(createWithName:) withObject:@"Acme Inc."];
         }];
     }
     [self removeAll];
}
*/


-(NSManagedObject*) newEntity {
	return block();
}


-(void) removeAll {
	if ([self class]==[GenericDaoTest class]) return;
    [dao removeAllByClassName:NSStringFromClass(moClass)];
	int moNumber = [dao count:NSStringFromClass(moClass)];
	STAssertTrue(moNumber==0, @"There should be no %@ instances.", moClass);
}


- (void) test11Create {
	if ([self class]==[GenericDaoTest class]) return;
    [self newEntity];
	int moNumber = [dao count:NSStringFromClass(moClass)];
	STAssertTrue(moNumber==1, @"There should be 1 %@ instead %d.", moClass, moNumber);
}


- (void) test12Remove {
	if ([self class]==[GenericDaoTest class]) return;
	NSManagedObject *mo;
	int moNumber;
	
	// create, remove, count
    mo = [self newEntity];
	[dao remove:mo];
	moNumber = [dao count:NSStringFromClass(moClass)];
	STAssertTrue(moNumber==0, @"There should be 0 %@ instead %d.", moClass, moNumber);
	
	// create, search, remove, count
	mo = [self newEntity];
	mo = [[dao objectsOfEntityName:NSStringFromClass(moClass)] lastObject];
	[dao remove:mo];
	moNumber = [dao count:NSStringFromClass(moClass)];
	STAssertTrue(moNumber==0, @"There should be 0 %@ instead %d.", moClass, moNumber);
}


- (void) dealloc {
	if (dao) [dao release];
    if (block) [block release];
	[super dealloc];
}


@end
