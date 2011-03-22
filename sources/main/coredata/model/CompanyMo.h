
#import <CoreData/CoreData.h>
#import "Mo.h"
#import "JsonEscape.h"

@class JobMo;

@interface CompanyMo :  Mo  
{
}

// coordinate
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

// jobs by this company
@property (nonatomic, retain) NSSet    *jobs;

// address, city, country
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;

// fragment of the url that returns this data
@property (nonatomic, retain) NSString *key;

// url to the company logo png
@property (nonatomic, retain) NSString *logo;

// company name
@property (nonatomic, retain) NSString *name;

// postcode, region
@property (nonatomic, retain) NSString *postcode;
@property (nonatomic, retain) NSString *region;

// url with company data
@property (nonatomic, retain) NSString *url;


-(BOOL) isValid;
-(NSString*) shortDescribe;
-(NSString*) fullAddress;
-(NSString*) describeContents;

@end


@interface CompanyMo (CoreDataGeneratedAccessors)
- (void)addJobsObject:(JobMo *)value;
- (void)removeJobsObject:(JobMo *)value;
- (void)addJobs:(NSSet *)value;
- (void)removeJobs:(NSSet *)value;
@end

