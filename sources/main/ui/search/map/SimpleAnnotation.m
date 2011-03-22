
#import "SimpleAnnotation.h"

@implementation SimpleAnnotation

@synthesize coordinate, title, subtitle, color;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    if ((self = [super init])) {
        self.coordinate = coord;
		self.color = MKPinAnnotationColorGreen;
    }
    return self;
}


- (void)dealloc {
    [title release];
    [subtitle release];
    [super dealloc];
}


@end
