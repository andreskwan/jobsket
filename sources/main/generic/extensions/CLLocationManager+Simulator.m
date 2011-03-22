

#import "CLLocationManager+Simulator.h"

@implementation CLLocationManager (Simulator)

/*
#ifdef MYTARGET_SIMULATOR 
-(void)startUpdatingLocation {
	static NSTimer *startUpdatingLocation_timer;
	CLLocation *puertadelsol = [[[CLLocation alloc] initWithLatitude:40.4166419 longitude:-3.7033122] autorelease];
	[self.delegate locationManager:self
			   didUpdateToLocation:puertadelsol
					  fromLocation:puertadelsol];
	if (startUpdatingLocation_timer==nil){
		debug(@"Starting timer");
		startUpdatingLocation_timer = [NSTimer scheduledTimerWithTimeInterval:5 
																	   target:self 
																	 selector:@selector(startUpdatingLocation) 
																	 userInfo:nil 
																	  repeats:YES];
	}
}
#endif
*/

@end
