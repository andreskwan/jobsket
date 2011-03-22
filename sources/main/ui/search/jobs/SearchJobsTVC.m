

#import "SearchJobsTVC.h"


@implementation SearchJobsTVC

@synthesize jobDetail, jobMap;
@synthesize navController, tableView;
@synthesize segmentedControl, labelBackground;
@synthesize fakeSectionHeader, statusLabel;
@synthesize searchMo, jobs;
@synthesize delegate;
@synthesize uiTabBarController;


static NSDateFormatter *formatter;


-(void) reload {
	// set jobs from the SearchMo
	if (jobs!=[[searchMo jobs] allObjects]){
	    jobs = [[[searchMo jobs] allObjects] retain];
	}
}


-(void) sortNewest {
	// sort by date
	jobs = [jobs sortedArrayUsingComparator: ^(id job1, id job2) {
		return (NSComparisonResult)[[job1 date] compare:[job2 date]];
	}];
	[jobs retain];
	
	// reload table
	[self.tableView reloadData];
}


-(void) sortNearest {
	debug(@"doh");
}


// !!!!!!!!!!
-(void) pushMap {
	debug(@"PUSHING Map View Controller");
	jobMap.jobs = self.searchMo.jobs;
	[navController pushViewController:jobMap animated:YES];
}


/*
// !!!!!!!!!!
// Handle clicks on the segmented control.
- (void) handleSegmentedControl: (UISegmentedControl *) seg {
	if (seg.selectedSegmentIndex == 0) {
		[self sortNewest];
    } else if (seg.selectedSegmentIndex == 1) {
		[self sortNearest];
	} else if (seg.selectedSegmentIndex == 2) {
		[self pushMap];
	}
}
*/


# pragma mark -
# pragma mark UIViewController


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    // show the tab indicator in case we are back from job detail
	self.delegate.tabBarArrow.hidden = FALSE;
}



- (void)viewWillAppear:(BOOL)animated {
	
    [self reload];
	
	// set segmentedControl to none selected
	segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
	
	// set table background
	self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[Themes getCachedImage:PNG_TABLE_BG]] autorelease];
	
	// reload and repaint
	[self.tableView reloadData];
	[[self.tableView layer] setNeedsDisplay];

    statusLabel.frame = CGRectMake(13, 0, 300, 22);
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = UIColorFromRGB(0xFFFFFF);
    statusLabel.shadowColor = UIColorFromRGB(0x64696E);
    statusLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    statusLabel.font = [UIFont systemFontOfSize:16];
    
    if ([jobs count]==0){
        statusLabel.text = [NSString stringWithString:localize(@"job.status.noJobs")];
    } else if ([jobs count]==1){
        statusLabel.text = [NSString stringWithFormat:localize(@"job.status.oneJob"), [jobs count]];
    } else {
        statusLabel.text = [NSString stringWithFormat:localize(@"job.status.manyJobs"), [jobs count]];
    }

}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	// map button
	UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];  
	[mapBtn setBackgroundImage:[Themes getCachedImage:PNG_BTN_MAP_UP] forState:UIControlStateNormal];  
	[mapBtn setBackgroundImage:[Themes getCachedImage:PNG_BTN_MAP_UP] forState:UIControlStateSelected];  
	[mapBtn setBackgroundImage:[Themes getCachedImage:PNG_BTN_MAP_DOWN] forState:UIControlStateHighlighted];  
    [mapBtn addTarget:self action:@selector(pushMap) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [Themes getCachedImage:PNG_BTN_MAP_UP];
	mapBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    img = nil;
    UIBarButtonItem *mapBtnItem = [[[UIBarButtonItem alloc] initWithCustomView:mapBtn] autorelease];  
	self.navigationItem.rightBarButtonItem = mapBtnItem;
	
	
	// back button
	UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];  
	UIImage *backImage = [[Themes getCachedImage:PNG_TOP_BAR_SEARCH] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	[back setBackgroundImage:backImage forState:UIControlStateNormal];  
    [back addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	back.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIBarButtonItem *backbi = [[[UIBarButtonItem alloc] initWithCustomView:back] autorelease];  
	self.navigationItem.leftBarButtonItem = backbi;
	
	// remove separator
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// date formatter
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd/MM/YYYY"];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[searchMo jobs]count];
}


- (CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// dequeue cell
	static NSString *cellIdentifier = @"Cell";
    StyleSubtitleTVCell *cell = (StyleSubtitleTVCell*)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[StyleSubtitleTVCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	// set header text
	JobMo *job = [jobs objectAtIndex:[indexPath row]];
	cell.headerText = [job title];
	
	// set detail text
	NSMutableArray *array = [NSMutableArray new];
	if (job.city) [array addObject:job.city];
	if ([job.company name]) [array addObject:[job.company name]];
    cell.detailText = [array componentsJoinedByString:@", "];
	[array release];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // onethread
    [self selectJob:indexPath];
	//[NSThread detachNewThreadSelector:@selector(selectJob:) toTarget:self withObject:indexPath]; 
}



-(void) selectJob:(NSIndexPath *)indexPath {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// set the job in the detail controller
	JobMo *jobMo = [jobs objectAtIndex:[indexPath row]];
	jobDetail.jobMo = jobMo;

	// if the job misses fields (because we built it from the search results)
	// then download the job details page and fill it
	if ([jobMo needsFilling]){
		debug(@"Reading job from http://ats.jobsket.com/api/job/%@", jobMo.identifier, jobMo.identifier);
		NSString *url = [NSString stringWithFormat:@"http://ats.jobsket.com/api/job/%@", jobMo.identifier];
		
		NSString *json = [[[HttpDownload new]autorelease] pageAsStringFromUrl:url];
		
        if (json==nil) {
            // The query only fails when there is no connectivity.
            // Nothing else to do. HttpDownload should have already spawned a warning hud.
            warn(@"Query failed. Nothing else to do");
            return;
        }
        
		jobMo = [[[JsonMoBuilder new]autorelease] parseJob:json];
		jobMo.lastRefresh = [NSDate date];
	    jobDetail.jobMo = jobMo;
		
		debug(@"[job describe] = %@", [jobMo describe]);
	}
	
	[self performSelectorOnMainThread:@selector(pushJobDetail) withObject:nil waitUntilDone:false];
	
	//[pool release];
}



-(void) popViewController {
	[self.navigationController popViewControllerAnimated:YES]; 
}



-(void) pushJobDetail {
	// hide the tab indicator before showing the job detail
	//self.delegate.tabBarArrow.hidden = TRUE;
	
	// nytimes bars
	//jobDetail.hidesBottomBarWhenPushed = YES;
	
	jobDetail.uiTabBarController = self.uiTabBarController;
	jobDetail.delegate = self.delegate;
	
	[navController pushViewController:jobDetail animated:YES];
}



#pragma mark -
#pragma mark Memory management


- (void)dealloc {
    [super dealloc];
}


@end

