
#import <CoreData/CoreData.h>
#import "Mo.h"

@class CompanyMo;
@class SearchMo;

@interface JobMo :  Mo  
{
}


// Date of the last refresh for the detail data of this job.
// This is nil when the job has been created in the search page, but details have never been downloaded.
@property (nonatomic, retain) NSDate *lastRefresh;


// company that posted this job
@property (nonatomic, retain) CompanyMo *company;

// date this job was posted on
@property (nonatomic, retain) NSDate   *date;

// 1 = favorite, 0 = not favorite
@property (nonatomic, retain) NSNumber *favorite;

// String from a fixed set. Value is taken from JSON and not checked against that set. 
// Shown on detail page.
@property (nonatomic, retain) NSString *category;

// city this job is on
@property (nonatomic, retain) NSString *city;

// description of the job
@property (nonatomic, retain) NSString *content;

// String from a fixed set. Value is taken from JSON and not checked against that set. 
// Shown on detail page.
@property (nonatomic, retain) NSString *experience;

@property (nonatomic, retain) NSNumber *identifier;

// ???
@property (nonatomic, retain) NSString *location;

// Min/max salary of the job. It is a number in JSON.
@property (nonatomic, retain) NSNumber *maxSalary;
@property (nonatomic, retain) NSNumber *minSalary;

// Shown on detail page.
// Not present in JSON. Parsed from the page.
@property (nonatomic, retain) NSString *other; // html

// Place the job is on.
@property (nonatomic, retain) NSString *place;

// Not sure what the type is in JSON.
@property (nonatomic, retain) NSString *reference;

// Region. Appears on the job when we do a search.
@property (nonatomic, retain) NSString *region;

// Shown on detail page.
// Not present in JSON. Parsed from the page.
@property (nonatomic, retain) NSString *requirements;

// String from a fixed set: { Open, Close } 
// Value is taken from JSON and not checked against that set. 
@property (nonatomic, retain) NSString *status;

// Title of the job
@property (nonatomic, retain) NSString *title;

// URL of the job
@property (nonatomic, retain) NSString *url;

// NSNumber in JSON
@property (nonatomic, retain) NSNumber *visits;


//@property (nonatomic, retain) SearchMo *search;
@property (nonatomic, retain) NSSet *searches; 


-(NSString *) describe;


-(NSString *) shortDescribe;


-(BOOL) isValid;

/** 
 * Returns true if the job doesn't include detail fields.
 *
 * If the job doesn't have any of the fields from the job detail page,
 * we need to download the page and extract those fields.
 */
-(BOOL) needsFilling;


/**
 * That.
 */
-(void) addSearch:(SearchMo*)searchMo;


@end


@interface JobMo()
-(NSString*) describeString:(NSString*)string;
-(NSString*) describeNumber:(NSNumber*)number;
-(NSString*) describeDate:(NSDate*)date;
@end


