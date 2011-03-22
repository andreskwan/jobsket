
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Random.h"


/** Company location lookup. */
@interface CompanyLookup : NSObject {
    Random *random;
}

@property (nonatomic, retain) Random *random;


- (CLLocation*) locationByName:(NSString*) name;


@end
