
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CoreDataPersistentManager.h"
#import "Dao.h"
#import "JobMo.h"

/** 
 * This blocks creates an empty instance of whatever object the DAO is about. 
 * This is initialized on the overriden setUp method of the subclasses of this class.
 */
typedef id(^instance)(void);


/**
 * Base test class for DAO testing.
 * You are supposed to subclass this and override setUp as base to create a new DAO test.
 *
 * This class contains remove/create tests used on the subclasses.
 * This class is detected and run as a test case, but there is nothing to test here,
 * that's why I detect when this class is running alone and execute a 'return' on all test.
 */
@interface GenericDaoTest : SenTestCase {
    Dao *dao;
	Class moClass;
	instance block;
	CoreDataAbstractManager *manager;
}

@property (nonatomic, retain) Dao *dao;
@property (nonatomic, copy) instance block;
@property (nonatomic, assign) Class moClass;
@property (nonatomic, retain) CoreDataAbstractManager *manager;


/** Remove all instances. */
- (void) removeAll;


/** Create one instance. */
- (void) test11Create;


/** Runs the following operations: create, remove, count, create, search, remove, count. */
- (void) test12Remove;


/** 
 * Initializes the block responsible for creating new instances, and the DAO.
 * See the implementation for an example.
 */
- (void) setUpWithDao:(Class)theDao andMo:(Class)theMoClass;


@end
