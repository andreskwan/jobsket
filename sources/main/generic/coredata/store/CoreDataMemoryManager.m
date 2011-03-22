
#import "CoreDataMemoryManager.h"


@implementation CoreDataMemoryManager


#pragma mark -
#pragma mark CoreDataManager protocol



- (NSPersistentStoreCoordinator*) coordinator {
    if (!_coordinator) {
		NSError *error = nil;
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
		//NSPersistentStore *inMemoryStore = 
		[_coordinator addPersistentStoreWithType:NSInMemoryStoreType 
																	  configuration:nil URL:nil options:nil error:&error];
		//NSAssert(inMemoryStore && !error, @"Setup failed.");
	}
    return _coordinator;
}


-(void) resetStore {
	// remove the store from the coordinator
	NSPersistentStore *store = [[[self coordinator] persistentStores] lastObject];
	NSError *error;
	[[self coordinator] removePersistentStore:store error:&error];
	//NSPersistentStore *inMemoryStore = 
	[[self coordinator] addPersistentStoreWithType:NSInMemoryStoreType 
																  configuration:nil URL:nil options:nil error:&error];
	//NSAssert(inMemoryStore && !error, @"Setup failed.");
}


@end
