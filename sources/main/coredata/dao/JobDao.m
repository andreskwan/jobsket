
#import "JobDao.h"
#import "CoreDataPersistentManager.h"


@implementation JobDao


/** 
 * Create a job.
 * The job is NOT saved before returning it.
 */
-(JobMo*) job {
	NSManagedObjectContext *context = [[self manager] context];
	
	return (JobMo*) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobMo class]) 
												  inManagedObjectContext: context];
}


/** 
 * Create a job with the given title and url.
 *
 * The job is saved before returning it.
 * Title and url are the only mandatory fields in a job.
 */
-(JobMo*) jobWithName:(NSString*)name andUrl:(NSString*)url {
	NSManagedObjectContext *context = [[self manager] context];
	
	JobMo *job = (JobMo*) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JobMo class]) 
														inManagedObjectContext: context];
	job.title = name;
	job.url = url;
	
	NSError *error;
	if ([context hasChanges] && ![context save:&error]) {
	    warn(@"Error %@", [error localizedDescription]);
	}
	
	return job;
}


- (NSArray *) findByFavorite:(NSNumber *) favorite {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite = %d", [favorite intValue]];
	NSArray *jobs = [super objectsOfEntityName:NSStringFromClass([JobMo class]) withPredicate:predicate];
    //debug(@"    %d hits for JobMo with favorite = %d", [jobs count], [favorite intValue]);
    return jobs;
}


- (JobMo*) findByUrl:(NSString*) url {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url = %d", url];
	NSArray *jobs = [super objectsOfEntityName:NSStringFromClass([JobMo class]) withPredicate:predicate];
    // url is unique for each job so there should be 1 or 0 jobs
	//debug(@"    %d hits for JobMo with url = %@", [jobs count], url);
    return [jobs count]==1 ? [jobs lastObject] : nil;
}


- (JobMo*) findByIdentifier:(NSNumber*) identifier {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %d", identifier];
	NSArray *jobs = [super objectsOfEntityName:NSStringFromClass([JobMo class]) withPredicate:predicate];
	//debug(@"    %d hits for JobMo with identifier = %@", [jobs count], identifier);
    // identifier is unique for each job so there should be 1 or 0 jobs
    return [jobs count]==1 ? [jobs lastObject] : nil;
}


@end
