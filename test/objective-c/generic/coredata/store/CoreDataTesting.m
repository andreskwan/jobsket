
#import <CoreData/CoreData.h>
#import "CoreDataAbstractManager.h"
#import "JobDao.h"
#import "CoreDataTesting.h"

@implementation CoreDataTesting

@synthesize manager=_manager;

/**
 * Test there are entities in the model 
 */
- (BOOL) test1Entities {
	NSManagedObjectModel *model = [[self manager] model];
	NSArray *entities = [model entities];
	for (NSEntityDescription *entity in entities){
		debug(@"found entity: %@", [entity name]);
	}
	return [entities count]>0;
}


/** 
 * Test there is at least one JobMo, and his title is not null.
 */
- (BOOL) test5KVC {
	debug(@"%@",NSStringFromSelector(_cmd));
	JobDao *jobDao = [[JobDao alloc] initWithManager:[self manager]];
	NSArray *array = [jobDao objectsOfEntityName:NSStringFromClass([JobMo class]) withBatchSize:1];
	//Job *job = [array lastObject];
	NSManagedObject *mo = [array lastObject];
	NSString *title = [mo valueForKey:@"title"];
	debug(@"%@",title);
	return title!=nil;
}


/**
 * Test the singleton returns the same instance.
 */
- (BOOL) test2Singleton {
	debug(@"%@",NSStringFromSelector(_cmd));
	// check context returns a single instance
	NSManagedObjectContext *context1 = [[self manager] context];
	NSManagedObjectContext *context2 = [[self manager] context];
	return context1 == context2;
}


/**
 * Test that we are able to remove all JobMo entities. 
 */
- (BOOL) test3RemoveAll {
	debug(@"%@",NSStringFromSelector(_cmd));
	// create entity, remove all, and check the number of entities is 0
	JobDao *jobDao = [[JobDao alloc] initWithManager:[self manager]];
	NSString *className = NSStringFromClass([JobMo class]);
	[jobDao removeAllByClassName:className ];
	int jobNumber = [[jobDao objectsOfEntityName:className] count];
	return jobNumber == 0;
}


/**
 * Test that we are able to create 10 JobMo.
 */
- (BOOL) test4Create {
	debug(@"%@",NSStringFromSelector(_cmd));
	JobDao *jobDao = [[JobDao alloc] initWithManager:[self manager]];
	// create 10 entities
	int i;
	for (i=0; i<10; i++) {
		NSString *title = [NSString stringWithFormat:@"Title %d",i];
		NSString *content = [NSString stringWithFormat:@"Content %d",i];
		JobMo *jobMo1 = [jobDao jobWithName:title andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob1"];
		jobMo1.content = content;
		jobMo1.date = [NSDate date];
	}
	int jobNumber = [[jobDao objectsOfEntityName:NSStringFromClass([JobMo class])] count];
	return jobNumber == 10;
}


-(void)dealloc {
	[super dealloc];
	[[self manager] manualDealloc];
}


@end
