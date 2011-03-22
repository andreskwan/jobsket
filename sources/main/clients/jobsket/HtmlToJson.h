
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "XPathQuery.h"
#import "JsonEscape.h"
#import "DebugLog.h"

@interface HtmlToJson : NSObject {
}

/**
 * Parse the HTML job search results from Jobsket, 
 * and returns the jobs as JSON.
 */
-(NSString*) jsonJobsFromData:(NSData *)htmlSearchData;


/**
 * Parse the HTML job detail from Jobsket, 
 * and returns the data as JSON.
 */
-(NSString*) jsonJobDetailFromData:(NSData *)htmlSearchData;
	


@end