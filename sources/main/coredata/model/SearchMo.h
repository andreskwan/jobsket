
#import <CoreData/CoreData.h>
#import "Mo.h"
#import "JsonEscape.h"
#import "Themes.h"
#import "JobMo.h"
#import "PickersData.h"


@class JobMo;

@interface SearchMo :  Mo {
}

// search terms used
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *experience;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *maxSalary;
@property (nonatomic, retain) NSString *minSalary;
@property (nonatomic, retain) NSString *keywords;
@property (nonatomic, assign) NSNumber *favorite;
@property (nonatomic, retain) NSDate   *date;
//@property (nonatomic, retain) NSDate   *lastUpdated;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSSet    *jobs;

/** Return a string representation of the object. */
-(NSString *) shortDescribe;

/** Return a string representation of the object. */
-(NSString *) describe;

-(NSString*) describeJobs;

/* Return a label to display on the search cell. */
-(NSString*) cellLabel;


@end


@interface SearchMo (CoreDataGeneratedAccessors)
- (void)addJobsObject:(JobMo *)value;
- (void)removeJobsObject:(JobMo *)value;
- (void)addJobs:(NSSet *)value;
- (void)removeJobs:(NSSet *)value;

@end

