
#import "Dao.h"
#import "CoreDataAbstractManager.h"
#import "CoreDataPersistentManager.h"


@implementation Dao {
}

@synthesize manager;


/**
 * Init with a CoreDataPersistentManager.
 */
- (id) init {
	return [self initWithManager:[CoreDataPersistentManager sharedInstance]];
}


/**
 * Designated initializer.
 */
- (id) initWithManager:(CoreDataAbstractManager*) mgr {
    self = [super init];
    if (self != nil){
        self.manager = mgr;
    }
    return self;
}


/**
 * Save changes to the context.
 */
-(void) save {
	NSManagedObjectContext *context = [[self manager] context];
	NSError *error;
	if ([context hasChanges] && ![context save:&error]) {  // TODO: EXC_BAD_ACCESS
	    warn(@"Error saving %@ %@, %@, %@", [self class], error, [error userInfo],[error localizedDescription]);
	}
}


/** 
 * Get the context from the CoreDataManager singelton.
 * @todo implement
 */
-(NSManagedObjectContext*) context {
	return [ (CoreDataAbstractManager*)[[manager class] sharedInstance] context];
}


-(NSString *) describe:(NSManagedObject *) mObj {
	NSString *result;
	if ( [mObj respondsToSelector: @selector(describe)] ) {
		result = [mObj performSelector:@selector(describe)]; 
    } else {
		result = [NSString stringWithFormat: @"%@[objectId=%@, ...]", [[mObj entity]name], [mObj objectID] ];
	}	
	return result;
}


-(NSArray*) objectsOfEntityName:(NSString*) entity {
	// batch=0 disables batching 
	return [self objectsOfEntityName:entity withBatchSize:0];  
}


-(int) count:(NSString*) entity {
	int i = [[self objectsOfEntityName:entity withBatchSize:0] count];
	debug(@"counting entities %@ = %d", entity, i);
	return i;
}


-(void) dump:(NSString*) entity {
	debug(@"DUMPING %@", entity);
	NSMutableString *string = [NSMutableString stringWithFormat:@""];
	NSArray *array = [self objectsOfEntityName:entity withBatchSize:0];
	for (NSUInteger i = 0; i < [array count]; i++) {
		NSObject *obj = [array objectAtIndex:i];
		if ([obj respondsToSelector:@selector(longDescribe)]) {
		    [string appendString:[obj performSelector:@selector(longDescribe)] ];
		} else if ([obj respondsToSelector:@selector(describe)]) {
			[string appendString:[obj performSelector:@selector(describe)]];
		} else {
			[string appendFormat:@"%@ has no describe method.", [self class]];
		}
	}
	debug(@"%@", string);
}


-(NSArray*) objectsOfEntityName:(NSString*)entity withBatchSize:(NSInteger)size {
	// create request
	NSEntityDescription *entDesc = [NSEntityDescription entityForName:entity
											   inManagedObjectContext:[self context]];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entDesc];
	
	if (size){
		[fetchRequest setFetchBatchSize:size];
	}
	
	// execute request
	NSError *error;
	NSArray *fetchResults = [[self context] executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
    
	// clean up
	if(fetchResults == nil) {
		warn(@"an error occurred");
		[error release];
	}
    
	return fetchResults;
}

	
-(NSArray*)objectsOfEntityName:(NSString*)name 
           withPredicate:(NSPredicate*)predicate {
	// batch=0 disables batching 
    return [self objectsOfEntityName:name withPredicate:predicate andBatchSize:0];  
}
	

// TODO: crashing because its being called from multiple threads using the same context

-(NSArray*)objectsOfEntityName:(NSString*)name 
		   withPredicate:(NSPredicate*)predicate
				 andBatchSize:(NSInteger)size {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; 
	[fetchRequest setEntity:[NSEntityDescription entityForName:name
										inManagedObjectContext:[self context]]];
	if (predicate){
        [fetchRequest setPredicate:predicate];
	}
	if (size){
	    [fetchRequest setFetchBatchSize:size];
	}
    
    NSError *error = nil; 	
	NSArray *results = [[self context] executeFetchRequest:fetchRequest error:&error];  // TODO: EXC_BAD_ACCESS, collection mutated while being enumerated
	[fetchRequest release], fetchRequest = nil;
	
	if (error) { 
		warn(@"%@:%s Error on fetch %@", [self class], _cmd, error); 
		return nil;
	} 
	return results;
}


-(void) removeAllByClassName:(NSString*) name {
	debug(@"    Removing all entities with name %@",name);
	NSManagedObjectContext *context = [self context];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:context];
	//debug(@"NSEntityDescription for name %@ is %@", name, desc);
	[fetchRequest setEntity:desc];
	
	NSError *error = nil;
	NSArray *managedObjects = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	for (NSManagedObject *managedObject in managedObjects) {
		[context deleteObject:managedObject];
		// debug
		if ([managedObject respondsToSelector:@selector(describe)] == YES) {
			debug(@"Deleting: %@", [managedObject performSelector:@selector(shortDescribe)]);
		} else {
			debug(@"Deleting: %@", managedObject);
		}
	}
    if (![context save:&error]) {
        warn(@"Error saving changes: %@", error);
    }
}


-(void) remove:(NSManagedObject*) objectToRemove { 
	[[self context] deleteObject:objectToRemove];
	
	NSError *error;
    if (![[self context] save:&error]) {
        warn(@"Error saving changes: %@", error);
    }
}


@end
