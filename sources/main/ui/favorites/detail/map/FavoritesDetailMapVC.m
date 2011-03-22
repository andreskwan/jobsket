
#import "FavoritesDetailMapVC.h"

@implementation FavoritesDetailMapVC

@synthesize mapView, locationManager, jobs, geocoding;


/*
-(void) pushARKitVC {
	NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithCapacity:10];
    arKitVC.locations = [NSArray arrayWithArray:tempLocationArray];
    [tempLocationArray release];
    //debug(@"pushing %@ \n on %@",arKitVC, self.navigationController);
    [self.navigationController pushViewController:arKitVC animated:TRUE]; 
}
*/


-(void) popViewController {
	[self.navigationController popViewControllerAnimated:YES]; 
}


- (void)centerMap:(CLLocation *)location area:(int)meters {
    // CLLocation *userLoc = [[mapView userLocation] location];
	CLLocationCoordinate2D userCoords = [location coordinate];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoords, meters, meters);
	[mapView setRegion:region animated:YES];
}


- (void)centerMapOnAnnotations {
	NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
	
	// get the minimum and maximum coordinates
	CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
	CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
	for(NSValue *value in coordinates) {
		CLLocationCoordinate2D coord = {0.0f, 0.0f};
		[value getValue:&coord];
		if(coord.longitude > maxCoord.longitude) {
			maxCoord.longitude = coord.longitude;
		}
		if(coord.latitude > maxCoord.latitude) {
			maxCoord.latitude = coord.latitude;
		}
		if(coord.longitude < minCoord.longitude) {
			minCoord.longitude = coord.longitude;
		}
		if(coord.latitude < minCoord.latitude) {
			minCoord.latitude = coord.latitude;
		}
	}
	
	// create a region
	MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
	region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
	region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
	region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
	region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
	
	// add a 10% margin so we see the whole pin
	region.span.longitudeDelta += region.span.longitudeDelta*.4;
	region.span.latitudeDelta += region.span.latitudeDelta*.4;
	
	// move center a bit down (dunno why the fuck, but shit appears too high otherwise)
	region.center.latitude += (region.span.latitudeDelta *.2);
	
	// center the map on that region
	[self.mapView setRegion:region animated:YES];
}



-(void) addPins {
	
	debug(@"Adding pins for %d jobs", [jobs count]);
	
	if (self.jobs==nil) return;
	
	int annotationsCreated = 0;
	
	// iterate on all jobs
	for (JobMo *job in self.jobs) {
		
		//debug(@"job: %@", [job describe]);
		
		CLLocation *location = nil;
		BOOL usingJobLocation = FALSE;
		{
			if (job==nil) continue; // job is nil
			if (job.company==nil) {	
				// case where company is nil
				if (job.city==nil) continue; // company and job.city are nil
				location = [geocoding geocodeCity:job.city];
				if (location==nil) continue; // company is nil, job.city isn't, but couldn't geocode job.city
				usingJobLocation = TRUE;
			} else {
				// case where company is NOT nil
				NSNumber *latitude = job.company.latitude;
				if (latitude==nil) {
					if (job.city==nil) continue; // company.latitude and job.city are nil
					location = [geocoding geocodeCity:job.city];
					if (location==nil) continue; // company.latitude is nil, job.city isn't, but couldn't geocode job.city
					usingJobLocation = TRUE;
				} else {
					CLLocationDegrees latitude = [job.company.latitude doubleValue];
					CLLocationDegrees longitude = [job.company.longitude doubleValue];		
					location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                    [location autorelease];
				}
			}
		}
		
		// create the annotation
		CLLocationCoordinate2D coords = { location.coordinate.latitude, location.coordinate.longitude }; 
        if (coords.latitude!=0 && coords.longitude!=0){
            SimpleAnnotation *annotation = [[SimpleAnnotation alloc] initWithCoordinate:coords];
            annotation.title = job.title; 
            annotation.subtitle = job.company.name;
            annotation.color = usingJobLocation ? MKPinAnnotationColorPurple : MKPinAnnotationColorGreen;
            [mapView addAnnotation:annotation];
            [annotation release];
            annotationsCreated++;            
        } else {
            debug(@"Missing location for company in job titled %@", job.title);
        }

	}
	
	debug(@"%d annotations for %d jobs", annotationsCreated, [jobs count]);
		
	// center map
	if (annotationsCreated==1){
		// if there is only one job we use a 2km^2 area
		debug(@"center on the job annotation");
		JobMo *job = [self.jobs anyObject];
		CLLocationDegrees latitude = [job.company.latitude doubleValue];
		CLLocationDegrees longitude = [job.company.longitude doubleValue];		
		CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [self centerMap:location area:2000]; // 2km * 2km
		return;
	} else if (annotationsCreated>1){
		// several jobs
		debug(@"center on annotations");
		[self centerMapOnAnnotations];
	} else {
		// oww fuck, no annotations
	}
	
}


#pragma mark -
#pragma mark CLLocationManagerDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	SimpleAnnotation *ann = (SimpleAnnotation *)annotation;
	
	debug(@"annotation color = %d", ann.color);
    MKPinAnnotationView *view = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
	
    if(!view) {  // create one if view is nil
        view = [[MKPinAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:@"PIN_ANNOTATION"];
        [view autorelease];
    }
    [view setCanShowCallout:YES];  // view displayed when the user touches the annotation
    [view setPinColor:ann.color];
    [view setAnimatesDrop:YES];
    return view;
}


/*
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	
	debug(@"Ping: %@,%@", [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.latitude],
                    [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.longitude]);

	[self centerMap:newLocation area:500000];
	
	//[locationManager stopUpdatingLocation];
}
*/


#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[mapView setDelegate:self];
	[mapView setShowsUserLocation:NO];
	
	geocoding = [[Geocoding alloc] init];

	warn(@"FUUUUUUUCK !");
    
	// back button
	UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];  
	UIImage *backImage = [Themes getCachedImage:PNG_TOP_BAR_DETAIL];
	[back setBackgroundImage:backImage forState:UIControlStateNormal];  
    [back addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	back.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIBarButtonItem *backbi = [[[UIBarButtonItem alloc] initWithCustomView:back] autorelease];  
	self.navigationItem.leftBarButtonItem = backbi;
    
    // init the arkit controller, and add a button to the toolbar to push it
    //self.arKitVC = [[arKitVC alloc] init];
    
    UIBarButtonItem *ar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
                                                                         target:self 
                                                                         action:@selector(pushARKitVC)];
    [ar autorelease];
    ar.title=@"AR";
	self.navigationItem.rightBarButtonItem = ar;
}


- (void)viewWillAppear:(BOOL)animated {
	// remove annotations
	[mapView removeAnnotations:self.mapView.annotations];
}


-(void) viewDidAppear:(BOOL)animated {
	[self addPins];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark NSObject

- (void)dealloc {
    self.mapView = nil;
    [super dealloc];
}

@end
