
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Dao.h"
#import "JobMo.h"


/**
 * DAO for the Job entity.
 */
@interface JobDao : Dao {
}


/** 
 * Create a job.
 * The job is NOT saved before returning it.
 */
-(JobMo*) job;
	

/** 
 * Create a job with the given title and url.
 *
 * The job is saved before returning it.
 * Title and url are the only mandatory fields in a job.
 */
-(JobMo*) jobWithName:(NSString*)name andUrl:(NSString*)url;

- (NSArray*) findByFavorite:(NSNumber*) favorite;

- (JobMo*) findByUrl:(NSString*) url;

- (JobMo*) findByIdentifier:(NSNumber*) identifier;


@end
