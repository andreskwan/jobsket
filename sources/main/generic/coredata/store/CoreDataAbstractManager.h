
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Singleton.h"
#import "BundleLookup.h"
#import "CoreDataManager.h"


/** Core Data lifecycle. */
@interface CoreDataAbstractManager : Singleton <CoreDataManager> {

    NSManagedObjectContext       *_context;
    NSManagedObjectModel         *_model;
    NSPersistentStoreCoordinator *_coordinator;
}

@property (nonatomic, retain) NSManagedObjectContext       *_context;
@property (nonatomic, retain) NSManagedObjectModel         *_model;
@property (nonatomic, retain) NSPersistentStoreCoordinator *_coordinator;


#pragma mark -
#pragma mark CoreDataManager protocol


/** 
 * Return NSManagedObjectModel.
 *
 * @returns The entity model.
 */
- (NSManagedObjectModel*) findManagedObjectModel;


/**
 * Returns the managed object context. 
 * If it doesn't already exist, it is created and bound to the persistent store coordinator.
 *
 * @return Managed object context.
 */
- (NSManagedObjectContext*) context;


/**
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and 
 * the application's store added to it.
 *
 * @return Persistent store coordinator.
 */
- (NSPersistentStoreCoordinator*) coordinator;


/**
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created.
 *
 * @return Managed object model.
 */
- (NSManagedObjectModel*) model;


/** 
 * Remove the persistent store. 
 */
- (void) resetStore;


/** 
 * Save changes to the context if any. 
 */
- (void) saveContext;


/** 
 * The Singleton class prevents dealloc from being called.
 * Call this method manually if you want clean up.
 */ 
- (void)manualDealloc;

 
@end
