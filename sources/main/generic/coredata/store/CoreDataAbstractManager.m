
#import "CoreDataAbstractManager.h"


/**
 * Don't use this class directly.
 * The following methods will throw NSInternalInconsistencyException if not overriden:
 *     - (NSPersistentStoreCoordinator*) coordinator
 *     - (void) resetStore
 */
@implementation CoreDataAbstractManager

@synthesize _context;
@synthesize _model;
@synthesize _coordinator;


#pragma mark -
#pragma mark CoreDataManager protocol


- (NSPersistentStoreCoordinator*) coordinator {
	[NSException raise:NSInternalInconsistencyException
	            format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}


-(void) resetStore {
	[NSException raise:NSInternalInconsistencyException
	            format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]; 
}


- (NSManagedObjectModel*) findManagedObjectModel {
	
	// build the model from the bundle
	NSArray *array = [NSArray arrayWithObject:[BundleLookup getBundle]];
	NSManagedObjectModel *theModel = [NSManagedObjectModel mergedModelFromBundles:array]; 
	
	return theModel;
}


- (NSManagedObjectContext*) context {
	BOOL contextExists = _context != nil;
    if (!contextExists) {
		NSPersistentStoreCoordinator *coordinator = [self coordinator];
        if (coordinator != nil) {
            _context = [[NSManagedObjectContext alloc] init];
            [_context setPersistentStoreCoordinator:coordinator];
        } else {
			assert(false && "coordinator failed to initialize");
		}
	}
	return _context;
}


- (NSManagedObjectModel*) model {
	BOOL modelExists = _model != nil;
    if (!modelExists) {
		_model = [self findManagedObjectModel];
		debug(@"    Model has %d entities\n\n", (int) [[_model entities] count]); 
	}
    return _model;
}


- (void)saveContext {
    NSError *error = nil;
    if (_context != nil) {
        if ([_context hasChanges] && ![_context save:&error]) {
            warn(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();  // replace with UIAlert for release
        } 
    }
}  


- (void)manualDealloc {
	// release core data
    [_context     release];
    [_model       release];
    [_coordinator release];
	[super dealloc];
}


@end

