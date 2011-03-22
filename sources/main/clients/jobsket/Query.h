
#import <Foundation/Foundation.h>

@interface Query : NSObject {
    NSString *keywords;
	NSString *minSalary;
	NSString *maxSalary;
	NSString *category;
	NSString *location;
	NSString *experience;
}

@property(nonatomic,retain) NSString *keywords;
@property(nonatomic,retain) NSString *minSalary;
@property(nonatomic,retain) NSString *maxSalary;
@property(nonatomic,retain) NSString *category;
@property(nonatomic,retain) NSString *location;
@property(nonatomic,retain) NSString *experience;


-(BOOL) isValid;


/** 
 * Return the parameters as a JSON string.
 */
-(NSString*) json;


/** Return a url made from the keywords set. */
-(NSString *) urlForHtmlSearch;

/** Return a url made from the keywords set. */
-(NSString *) urlForJsonSearch;

@end


@interface Query()
/** Return the parameters of the url. */
- (NSString*) htmlParameters;
- (NSString*) jsonParameters;
@end



// http://www.jobsket.es/search?minSalary=13000&maxSalary=20000&keywords=Shit
// &category=4&location=4&experience=1 or less years in experience

