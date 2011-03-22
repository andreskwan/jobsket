
#import "SearchJobsDetailTVC.h"

#define MAX_HEIGHT 1000000.0f
#define CELL_FONT_SIZE 14.0f
#define CELL_FONT [UIFont fontWithName:@"Helvetica" size:14]
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN_HEADER 10.0f
#define CELL_CONTENT_MARGIN_CONTENT 30.0f
#define SHIFT 20.0f


@implementation SearchJobsDetailTVC

@synthesize navController, detailMapVC, tableView, jobMo;
@synthesize headerView, ltJobTitle, ltCompany, ltExperience, ltLocation, ltCategory, lvCompany, lvExperience, lvLocation, lvCategory;
@synthesize nameLabel, navBar, favButton;
@synthesize dateLabel;
@synthesize segControl, favoriteOn, favoriteOff;
@synthesize labels, values;
@synthesize parentWindow;
@synthesize uiTabBarController;
@synthesize delegate;


- (void) hidetabbar:(BOOL)hiddenTabBar {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	for(UIView *view in self.uiTabBarController.view.subviews){
		//debug(@"%@", view);
		if([view isKindOfClass:[UITabBar class]]) {
			
			if (hiddenTabBar) {
				[view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
			} else {
				[view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
			}
		} else {
			if (hiddenTabBar) {
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
			} else {
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
			}
		}
	}
	[UIView commitAnimations];	
	//hiddenTabBar = !hiddenTabBar;
}


- (void)share
{
    NSURL *url = [NSURL URLWithString:self.jobMo.url];
	SHKItem *item = [SHKItem URL:url title:jobMo.title];
    [SHKMail shareItem:item];
}


// nytimes bars
- (void)tapped:(UITapGestureRecognizer *)gesture {
    BOOL barsHidden = self.navigationController.navigationBar.hidden;
	
    //[self.navigationController setToolbarHidden:!barsHidden animated:YES];
    [self.navigationController setNavigationBarHidden:!barsHidden animated:YES];
	[self hidetabbar:barsHidden];
	
	// hide tabbar arrow indicator
	if (barsHidden==FALSE) {
		self.delegate.tabBarArrow.hidden = TRUE;
	} else{
		[self performSelector:@selector(hideArrow) withObject:nil afterDelay:0.5];
	}

}


-(void) hideArrow {
	self.delegate.tabBarArrow.hidden = FALSE;
}


////////////////////////////////////////////////////////////////////////////////////////////////////


-(void) popViewController {
	[self.navigationController popViewControllerAnimated:YES]; 
}


-(BOOL) isMultiline:(NSIndexPath*) indexPath {
	int i = [indexPath row];
	return i==0 || i==1 || i==2;
}


/**
 * Return the label for this row.
 */
- (NSString*) labelForRow:(NSIndexPath *)indexPath {
	return [indexPath row]<[labels count] ? [labels objectAtIndex:[indexPath row]] : @"?? missing label";
}


/**
 * Return the value for this row.
 */
- (NSString*) valueForRow:(NSIndexPath *)indexPath {
	
    /*
	// formatted date
	NSString *formattedDate = @"";
	if (jobMo.date){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"dd/MM/YYYY"];
		formattedDate = [formatter stringFromDate:jobMo.date];
	}
    */
	
	int i = [indexPath row];
	// set to an object from the array or to — if i went beyond array boundaries
	NSString *value = i<[values count] ? [values objectAtIndex:i] : @"";
	if ([value length]==0) value = @" "; // if empty string set to placeholder char
	return value;
}


#pragma mark -
#pragma mark UITableView Delegaates


/** 8 fields */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


/** 1 section */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *valueForRow = [self valueForRow:indexPath];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN_CONTENT * 2), MAX_HEIGHT);
	CGSize size = [valueForRow sizeWithFont:CELL_FONT 
						  constrainedToSize:constraint 
							  lineBreakMode:UILineBreakModeWordWrap];
	float f = size.height; // + SHIFT;
	f += [self isMultiline:indexPath] ? 20 : 0;
	
	// TODO que devuelva un margen minimo
	
	f = floor(f / 26)*26 + 26; // return multiples of 26
	//debug(@"height = %f, %f/26 = %f", f, f, f/26);
	
    return f;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier = [NSString stringWithFormat:@"%d %@", [indexPath row], [jobMo url]];
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier] autorelease];
		
		// cell background
		UIView *cellBackView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		cellBackView.backgroundColor = [UIColor colorWithPatternImage: [Themes getCachedImage:PNG_TABLE_JOBDETAIL_BG]];
		cell.backgroundView = cellBackView;
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if ([self isMultiline:indexPath]) {
			
			UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			{
				[headerLabel setMinimumFontSize:CELL_FONT_SIZE];
				[headerLabel setNumberOfLines:0];
				UIFont *font = [Themes getFont:FONT_JOBDETAIL_CELLTITLE];
				[headerLabel setFont:font];
				[headerLabel setTextColor:[Themes getColor:HEXCOLOR_JOBDETAIL_CELL_TITLE]];
				[headerLabel setBackgroundColor:[UIColor clearColor]];

				NSString *labelForRow = [self labelForRow:indexPath];
				[headerLabel setText:labelForRow];

				// calculate size for the given text
				CGSize size = [labelForRow sizeWithFont:[Themes getFont:FONT_JOBDETAIL_CELLTITLE]];

				[headerLabel setFrame:CGRectMake(15.0f,          // origin x is the margin
                                                 0.0f,           // + shift, // origin y is the margin plus extra vertical margin
                                                 320.0f - 10.0f, // width is the cell width minus 2x margins
                                                 size.height     // height
											    )];
			}
			[[cell contentView] addSubview:headerLabel];
            [headerLabel autorelease];
			
			UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			{
				[contentLabel setLineBreakMode:UILineBreakModeWordWrap];
				[contentLabel setMinimumFontSize:CELL_FONT_SIZE];
				[contentLabel setNumberOfLines:0];
				[contentLabel setFont:[Themes getFont:FONT_JOBDETAIL_CELLCONTENT]];
				[contentLabel setBackgroundColor:[UIColor clearColor]];
				 
				NSString *valueForRow = [self valueForRow:indexPath];
				[contentLabel setText:valueForRow];
				
				// constrained width, unconstrained height
				CGSize constraint = CGSizeMake(320.0f - 30.0f - 20.0f, 1000000.0f);//320.0f - 30.0f - 20.0f, 1000000.0f);
				
				// calculate size for the given text
				CGSize size = [valueForRow sizeWithFont:[Themes getFont:FONT_JOBDETAIL_CELLCONTENT] 
									  constrainedToSize:constraint 
			 							  lineBreakMode:UILineBreakModeWordWrap];
				
				// vertical margin
				//size.height += shift;
				
				// - (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode;
				
				[contentLabel setFrame:CGRectMake(30.0f, // origin x
												  [Themes getFont:FONT_JOBDETAIL_CELLTITLE].lineHeight *1.5, // origin y 
                                                  320.0f - 30.0f - 20.0f, // width
                                                  size.height // height
												 )];
			}
			[[cell contentView] addSubview:contentLabel];
			[contentLabel autorelease];
            
		}
		
	}	
	
	if (![self isMultiline:indexPath]){
		cell.textLabel.text = [self labelForRow:indexPath];
		cell.textLabel.font = CELL_FONT;
		cell.detailTextLabel.text = [self valueForRow:indexPath];
		cell.detailTextLabel.font = CELL_FONT;
		//debug(@"> %@ %@", cell.textLabel.text, cell.detailTextLabel.text);
	}

    return cell;
}


# pragma mark -
# pragma mark UIViewController


-(void)toggleFavorite {
	
	jobMo.favorite = [jobMo.favorite intValue]==0 ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
	debug(@"jobMo.favorite = %@", jobMo.favorite);
	JobDao *dao = [[JobDao alloc] initWithManager:[CoreDataPersistentManager sharedInstance]];
	[dao save];
    [dao release];
	
	// update image - commented because it's already set in the nib
	//[favBtn setBackgroundImage:([jobMo.favorite intValue]==0 ? favoriteOff : favoriteOn) forState:UIControlStateNormal]; 
	
	UIButton *button = [segControl buttonAtIndex:0];
	button.selected = [jobMo.favorite intValue] == 1;
	
	if ([jobMo.favorite intValue]==1){
		
		double duration = 0.5;
		
		UIView *viewToCapture = self.parentWindow;
		
		// capture the image of the tableView
		CGRect rect = viewToCapture.bounds;
		UIGraphicsBeginImageContext(rect.size);
		[viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		// crop to discard the borders of the image
		rect.origin.x = 5;
		rect.origin.y = 80;
		rect.size.width = rect.size.width-5;
		rect.size.height = 350;
		image = [image imageByCropping:image toRect:rect];
		
		// add the resulting image
		UIImageView *iv = [[[UIImageView alloc] initWithImage:image] autorelease];
		// 5,80 to position over the original captured image
		iv.frame = CGRectMake(5, 80, iv.frame.size.width, iv.frame.size.height);
		[viewToCapture addSubview:iv];
		
		// animate
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:duration];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		CGAffineTransform transform;
		transform = CGAffineTransformMakeTranslation(0,210);
		transform = CGAffineTransformScale(transform,.1,.1);
		iv.transform = transform;
		[UIView commitAnimations];
		
		// remove image after the animation
		[iv performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration];
	}
	
}



- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	self.labels = [NSArray arrayWithObjects:
                    /* @"Company",       // 0
                       @"Experience",    // 1
                       @"Date",          // 2
                       @"Location",      // 3
                       @"Category",      // 4
                       @"",              // 5 */
				   localize(@"job.detail.requirements"),  // 0
				   localize(@"job.detail.description"),   // 1
				   localize(@"job.detail.other"),         // 2
                       nil];
	
	self.values = [NSArray arrayWithObjects:
                    /* jobMo.company.name,  // 0
                       jobMo.experience,    // 1
                       formattedDate,       // 2
                       jobMo.location,      // 3
                       jobMo.category,      // 4
                       @"",                 // 5 */
                       jobMo.requirements,  // 0
                       jobMo.content,       // 1
                       jobMo.other,         // 2
                       nil];
	
	// reload data and repaint 
	// this avoids showing the same data when we change the job
	[self.tableView reloadData];
	[[self.tableView layer] setNeedsDisplay];
	
	self.ltJobTitle.font = [Themes getFont:FONT_JOBDETAIL_TITLE];
	
	self.ltCategory.font   = [Themes getFont:FONT_JOBDETAIL_CELLTITLE];
	self.ltCategory.textColor = [Themes getColor:HEXCOLOR_JOBDETAIL_CELL_TITLE];
	self.ltCategory.text = localize(@"job.detail.ltCategory");
	
	self.ltCompany.font    = [Themes getFont:FONT_JOBDETAIL_CELLTITLE];
	self.ltCompany.textColor = [Themes getColor:HEXCOLOR_JOBDETAIL_CELL_TITLE];
	self.ltCompany.text = localize(@"job.detail.ltCompany");
    
	self.ltExperience.font = [Themes getFont:FONT_JOBDETAIL_CELLTITLE];
	self.ltExperience.textColor = [Themes getColor:HEXCOLOR_JOBDETAIL_CELL_TITLE];	
	self.ltExperience.text = localize(@"job.detail.ltExperience");
	
	self.ltLocation.font   = [Themes getFont:FONT_JOBDETAIL_CELLTITLE];
	self.ltLocation.textColor = [Themes getColor:HEXCOLOR_JOBDETAIL_CELL_TITLE];	
	self.ltLocation.text = localize(@"job.detail.ltLocation");
	
	// set the job date
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"MMMM dd"];
    NSString *published = [NSString stringWithFormat:@"%@ %@", 
                           localize(@"job.detail.published"),
                           [formatter stringFromDate:jobMo.date]];
    UIFont *font = [Themes getFont:FONT_JOBDETAIL_PUBLISHED];
    self.dateLabel.font = font;    
	self.dateLabel.text = published;
	[formatter release];
    
	// label format
	self.nameLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.nameLabel.text = jobMo.title;
	
	// attach the header
	tableView.tableHeaderView = headerView;

	self.lvCompany.text = jobMo.company.name;
	self.lvExperience.text = jobMo.experience;
	self.lvLocation.text = jobMo.city;
	self.lvCategory.text = jobMo.category;

	// place the three buttons on the right side of the bar
	CGRect frame = CGRectMake(320-128-5, 0, 128, 29);
	[segControl.view setFrame:frame];
    segControl.view.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:segControl.view];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
	// back button
	UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];  
	UIImage *backImage = [Themes getCachedImage:PNG_TOP_BAR_JOBS];
	[back setBackgroundImage:backImage forState:UIControlStateNormal];  
    [back addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	back.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIBarButtonItem *backbi = [[[UIBarButtonItem alloc] initWithCustomView:back] autorelease];  
	self.navigationItem.leftBarButtonItem = backbi;
	
	debug(@"jobMo.favorite = %d", [jobMo.favorite intValue]);
	UIButton *button = [segControl buttonAtIndex:0];
	button.selected = [jobMo.favorite intValue] == 1;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // nytimes bars
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}



- (void)viewDidLoad {
	[super viewDidLoad];
	
	debug(@"\n");
	debug(@"SEARCH JOBS DETAIL /////////////////////////////////////////////////////////////////////");
	
	favoriteOn = [Themes getCachedImage:PNG_TOP_BAR_FAV_BTN_STAR]; //[UIImage imageNamed:@"toggleImageSelected.png"];
	favoriteOff = [Themes getCachedImage:PNG_TOP_BAR_FAV_BTN_SHALLOW]; //[UIImage imageNamed:@"toggleImageNormal.png"];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//self.tableView.backgroundColor = [UIColor colorWithPatternImage:[Themes getCachedImage:PNG_TABLE_JOBDETAIL_BG]];
	
	UIImage *image = [[Themes getCachedImage:PNG_TABLE_WOOD_BG] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.5];
	UIImageView *bgView = [[[UIImageView alloc] initWithImage:image] autorelease];
	self.tableView.backgroundView = bgView;
	
	// set self as delegate for the fake UISegmentedControl
	segControl.delegate = self;
	
	// this reference is to add the animated subview when the job is favorited
	parentWindow = ((SearchUINavigationController*) self.navigationController).aWindow;
	
	// nytimes bars
	//UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)] autorelease];
    //[self setToolbarItems:[NSArray arrayWithObject:item]];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:gesture];
    [gesture release];
}


# pragma mark -
# pragma mark UIViewController


- (void)dealloc {
    [super dealloc];
}


# pragma mark -
# pragma mark SegControlDelegate


- (void) touchUpInsideSegmentIndex:(int)index {
    switch (index) {
				
        case 0: // favorite
            [self toggleFavorite];
            break;

    	case 1: // map
			debug(@"PUSHING Map View Controller");
			detailMapVC.jobs = [NSSet setWithObject:jobMo];
			[navController pushViewController:detailMapVC animated:YES];
	    	break;
			
        case 2: // share
			[self share];
            break;
   }
}


@end
