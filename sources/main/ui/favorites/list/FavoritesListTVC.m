
#import "FavoritesListTVC.h"

@implementation FavoritesListTVC

@synthesize jobDao;
@synthesize favoritesDetailTVC;

@synthesize favoritesMapVC;
@synthesize navController, tableView;
@synthesize segmentedControl, statusLabel, labelBackground, fakeSectionHeader;
@synthesize searchMo, jobs;
@synthesize delegate;
@synthesize uiTabBarController;


static NSDateFormatter *formatter;


-(void) reload {
	// load data with favorite flag = 1
	self.jobs = [jobDao findByFavorite:[NSNumber numberWithInt:1]];
	debug(@"%d jobs", [self.jobs count]);
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


-(void) pushMap {
	debug(@"PUSHING Map View Controller");
	// we just need the jobs part, 
	// guess SearchMapVC should be refactored to just need the jobs
	//SearchMo *smo = [SearchMo new];
	//smo.jobs = [NSSet setWithArray:jobs];
	
	favoritesMapVC.jobs = [NSSet setWithArray:jobs];
	[navController pushViewController:favoritesMapVC animated:YES];
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
        statusLabel.text = [NSString stringWithString:localize(@"favoriteJob.status.none")];
    } else if ([jobs count]==1){
        statusLabel.text = [NSString stringWithFormat:localize(@"favoriteJob.status.one"), [jobs count]];
    } else {
        statusLabel.text = [NSString stringWithFormat:localize(@"favoriteJob.status.many"), [jobs count]];
    }
	
	fakeSectionHeader = [[UIImageView alloc] initWithImage:[Themes getCachedImage:PNG_SECTION_BG]];
	[fakeSectionHeader autorelease];

	/*
    // set label
	statusLabel.text = [NSString stringWithFormat:@"Found %d jobs.", [jobs count]];	
	statusLabel.textColor = [UIColor whiteColor];
	statusLabel.shadowColor = UIColorFromRGB(0x444444); // 0x54595E
	statusLabel.shadowOffset = CGSizeMake(0, 1);	
	statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	*/
}



- (NSString *)nibName
{
	return @"FavoritesListTVC";
}



- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.favoritesDetailTVC.navController = self.navController;
    
	jobDao = [[JobDao alloc] initWithManager:[CoreDataPersistentManager sharedInstance]];
	
	// remove separator
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// map button
	UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];  
	[mapBtn setBackgroundImage:[Themes getCachedImage:PNG_BTN_MAP_UP] forState:UIControlStateNormal];  
	[mapBtn setBackgroundImage:[Themes getCachedImage:PNG_BTN_MAP_UP] forState:UIControlStateSelected];  
	[mapBtn setBackgroundImage:[Themes getCachedImage:PNG_BTN_MAP_DOWN] forState:UIControlStateHighlighted];  
    [mapBtn addTarget:self action:@selector(pushMap) forControlEvents:UIControlEventTouchUpInside];
	mapBtn.frame = CGRectMake(0, 0, 32, 29);
    UIBarButtonItem *mapBtnItem = [[[UIBarButtonItem alloc] initWithCustomView:mapBtn] autorelease];  
	self.navigationItem.rightBarButtonItem = mapBtnItem;
	
    self.navigationItem.title = localize(@"favorites.bar.title");
	
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
    return [self.jobs count];
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
    //onethread
    [self selectJob:indexPath];
	//[NSThread detachNewThreadSelector:@selector(selectJob:) toTarget:self withObject:indexPath]; 
}



-(void) selectJob:(NSIndexPath *)indexPath 
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// set the job in the detail controller
	JobMo *jobMo = [self.jobs objectAtIndex:[indexPath row]];
	favoritesDetailTVC.jobMo = jobMo;
	
	// if the job misses fields (we built it from the search results)
	// then download the job details page and fill it
	if ([jobMo needsFilling]){
        HttpDownload *download = [HttpDownload new];
		NSData *jobDetailData = [download cleanPageAsDataFromUrl:jobMo.url];
        HtmlToJson *htmlToJson = [HtmlToJson new];
		NSString *json = [htmlToJson jsonJobDetailFromData:jobDetailData];
        JsonToMo *jsonToMo = [JsonToMo new];
		[jsonToMo fillin:jobMo with:json];
        [jsonToMo release];
        [download release];
        [htmlToJson release];
	}
	
	[self performSelectorOnMainThread:@selector(pushJobDetail) withObject:nil waitUntilDone:false];
	
	[pool release];
}



-(void) pushJobDetail {
	
	favoritesDetailTVC.uiTabBarController = self.uiTabBarController;
	favoritesDetailTVC.delegate = self.delegate;
	
	[self.navController pushViewController:favoritesDetailTVC animated:YES];
}



#pragma mark -
#pragma mark Memory management


- (void)dealloc {
    [super dealloc];
}


@end
