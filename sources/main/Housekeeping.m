
#import "Housekeeping.h"
#import "NSDate+Erica.h"

/**
 * 1st time run we read the companies from a bundled file and save them to Core Data.
 * Everytime we start the application, we read all the companies from the API and save them to Core Data.
 */
@implementation Housekeeping

@synthesize filename, extension;


- (id) init {
    self = [super init];
    if (self != nil){
        // we'll download, geolocate, and save all companies to this file
        self.filename = @"all-companies";
		self.extension = @"json";
    }
    return self;
}



-(void) refreshCompanies {

    // The 1st time run we read all the companies from a file, so hopefully
    // most of the companies will be in memory when we need them. To do this
    // only once, we will set an initialized marker in NSUserDefaults.
    
    static NSString *MARKER = @"initialized-from-bundle";
    
	// is 1st time run?
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
	BOOL firstTimeRun = ![defaults objectForKey:MARKER];
	if (firstTimeRun) {
        // initialize companies from the file in the application bundle
		[self initializeFromBundle];
		
		// set "initialized" marker
		[defaults setObject:[NSDate date] forKey:MARKER];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} 
	
	// now refresh from the internet 
	[self refreshFromInternet];
}


/**
 * Read companies from bundled file "1stTimeRun-companies.json" and save them to Core Data.
 */
-(void) initializeFromBundle {
	BundleFile *bundleFile = [[BundleFile alloc] initWithFilename:@"1stTimeRun-companies" andExtension:@"json"];
	JsonMoBuilder *jsonMoBuilder = [JsonMoBuilder new];
    [jsonMoBuilder parseCompanies:[bundleFile string]];
    [bundleFile release];
    [jsonMoBuilder release];
}


/**
 * Read companies from the internet.
 * Hopefully, most are already read from the "1stTimeRun-companies.json" file.
 */
-(void) refreshFromInternet {
	debug(@"Refreshing companies from the internet");
	
	DiskFile *file = [[DiskFile alloc] initWithFilename:self.filename andExtension:self.extension];
	BOOL isUpdated = [file exists] && [[file modificationDate] isToday];
	debug(@"    File %@ is %@.", [file describe], isUpdated ? @"updated" : @"outdated");
	
    if (!isUpdated){
		
        // download all files
		NSString *url = @"http://ats.jobsket.com/api/companies";
        HttpDownload *download = [HttpDownload new];
		NSString *json = [download pageAsStringFromUrl:url];
        [download release];

		// bail out if download fails
		if (json==nil) {
			debug(@"failed to download %@", url);
            [file release];
			return;
		}

		if ([file exists]){
			// return because byte length is the same
			if ([file.string length]==[json length]) {
			    debug(@"Same length, no need to update.");
                [file release];
			    return;
		    }
			
			// Delete so modificationDate is updated when we create the file again
            // (modification date only updates when the file is created).
            [file delete]; 
		}

		// Parse and save to core data.
	    // This will skip those companies already localized.
        JsonMoBuilder *builder = [JsonMoBuilder new];
		NSSet *companies = [builder parseCompanies:json];
		[builder release];
        
		// if parsing succeded, save to disk
		// this also serves to mark that we completed the operation
		if (companies!=nil) [file writeAsString:json];
	}    
    [file release];
}



@end
