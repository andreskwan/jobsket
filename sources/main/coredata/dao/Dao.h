
#import "CoreDataAbstractManager.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dao : NSObject {
	
@private
	CoreDataAbstractManager *manager;
}

@property (nonatomic, retain) CoreDataAbstractManager *manager;


/** Designated initializer. */
- (id) initWithManager:(CoreDataAbstractManager*) manager;


/** Save changes to the context. */
-(void) save;
	

/** Return the number of entities with the given name. */
-(int) count:(NSString*) entity;
	

/** Return an initialized context to perform Core Data operations. */
-(NSManagedObjectContext*) context;


/**
 * Return a string version of this object.
 * The string is created either calling the method describe 
 * (if the entity has that method), or using just the name 
 * and the objectId.
 *
 * @param The NSManagedObject whose representation we are looking for.
 * @return String representation of this NSManagedObject.
 */
-(NSString *) describe:(NSManagedObject *) mObj;
	
	
/**
 * Return all the entities with the given name.
 *
 * @param entity The name of the entity we are searching for.
 * @return Array of entities.
 */
-(NSArray*) objectsOfEntityName:(NSString*) entity;


/**
 * Return all the entities with the given name and restrict the number of results.
 *
 * @param entity The name of the entity we are searching for.
 * @param size   Number of results to return.
 * @return Array of entities.
 */
-(NSArray*) objectsOfEntityName:(NSString*)entity withBatchSize:(NSInteger)size;


/**
 * Search entities with the given name and filter the results with a predicate.
 *
 * @param name      Name of the entity.
 * @param predicate Predicate to filter the results.
 */
-(NSArray*)objectsOfEntityName:(NSString*)name 
		   withPredicate:(NSPredicate*)predicate;


/**
 * Search entities with the given name, filter the results with a predicate,
 * and restrict results.
 *
 * @param name      Name of the entity.
 * @param predicate Predicate to filter the results.
 * @param size      Number of results to return.
 */
-(NSArray*)objectsOfEntityName:(NSString*)name 
		   withPredicate:(NSPredicate*)predicate
				 andBatchSize:(NSInteger)size;

/**
 * Remove the given object.
 *
 * @param Object to delete.
 */
-(void) remove:(NSManagedObject*) objectToRemove;


/**
 * Remove all entities with the given class name.
 *
 * @param Name of the entities to remove.
 */
-(void) removeAllByClassName:(NSString*) name;


/** 
 * Print to console every entity handled by this DAO. 
 *
 * @param name Name of the entity.
 */
-(void) dump:(NSString*) entity;



@end
