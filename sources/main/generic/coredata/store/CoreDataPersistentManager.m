
#import "CoreDataPersistentManager.h"

#define SQLITE_FILE @"Model.sqlite"


/** 
 * Private methods.
 */
@interface CoreDataPersistentManager()

/**
 * Returns the path to the application's Documents directory.
 *
 * @return Application's Documents directory.
 */
- (NSString *) applicationDocumentsDirectory;

@end



@implementation CoreDataPersistentManager


- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark CoreDataManager protocol


- (NSPersistentStoreCoordinator*) coordinator {
    
	//debug(@"current coordinator is %@", _coordinator);
	
	BOOL coordinatorExists = _coordinator != nil;
	
    if (!coordinatorExists) {
		NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: SQLITE_FILE];
		
		debug(@"    Store URL: %@...", [path substringWithRange:NSMakeRange(0, 61)]);
		
        NSURL *storeURL = [NSURL fileURLWithPath: path];
        NSError *error = nil;
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];

        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, nil];

        
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
			
			// if we crashed because the model is incompatible, delete store and try again
			NSString *kIncompatibleModelErrorReason = @"The model used to open the store is incompatible with the one used to create the store";
            if ([[[error userInfo] objectForKey:@"reason"] isEqualToString:kIncompatibleModelErrorReason]) {
			
                // delete old store
				debug(@"%@, \nI'll delete the old store and try again.",kIncompatibleModelErrorReason);
                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
                
                // try again
                if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
				    warn(@"Unresolved error: %@, %@", error, [error userInfo]);
                    abort();
			    }
		    }
			
		}
    }

	
	/*	
	// lightweight migration
	[NSDictionary dictionaryWithObjectsAndKeys:
	                  [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
                      [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
                      nil];
	*/
	
    return _coordinator;
}



-(void) resetStore {
	
	// remove the store from the coordinator
	NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: SQLITE_FILE];
	NSPersistentStore *store = [[[self coordinator] persistentStores] lastObject];
	NSError *error;
	[[self coordinator] removePersistentStore:store error:&error];
	
	// remove the file
	[[NSFileManager defaultManager] removeItemAtPath:path error:&error];	
	
	// put the store back
	NSURL *storeURL = [NSURL fileURLWithPath: path];
	if (![[self coordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		warn(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}  
}


@end

