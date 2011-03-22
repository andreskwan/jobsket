
#import "SearchListTVC.h"

/**
 * To allow reordering I did this:
 *
 *     - Hide the delete icon while on edit mode.
 *       Return UITableViewCellEditingStyleNone from tableView:editingStyleForRowAtIndexPath:
 *
 *     - Set edit mode on the table.
 *       Add [tableView setEditing:YES animated:YES] in viewDidLoad.
 *
 *     - Allow selection while on edit mode.
 *       Add tableView.allowsSelectionDuringEditing = YES in ViewDidLoad. 
 *
 */
@implementation SearchListTVC

@synthesize sBar, button, advancedSearchTVC, searchJobsTVC;


/**
 * Refresh the arrays backing up this tableView using Core Data.
 */
-(void) refreshTableData {
    // get recents and favorites 
	SearchDao *searchDao = [SearchDao new];
	recents = [[searchDao findByFavorite:[NSNumber numberWithBool:NO]] retain];
	favorites = [[searchDao findByFavorite:[NSNumber numberWithBool:YES]] retain];
	
    const int limit = 50;
    
    // if there are more than 50 favorites, drop half of them
    if ([favorites count]>limit){
        int favoritesCount = [favorites count];
        warn(@"dropping favs, there are too many");
        for (int i=favoritesCount/2; i<favoritesCount; i++) {
            [searchDao remove:[favorites objectAtIndex:i]];
            [searchDao save];
        }
        [favorites release];
        favorites = [[searchDao findByFavorite:[NSNumber numberWithBool:YES]] retain];
    }

    // if there are more than 50 recents, drop half of them
    if ([recents count]>limit){
        int recentsCount = [recents count];
        warn(@"dropping recents, there are too many");
        for (int i=recentsCount/2; i<recentsCount; i++) {
            [searchDao remove:[recents objectAtIndex:i]];
            [searchDao save];
            
        }
        [recents release];
        recents = [[searchDao findByFavorite:[NSNumber numberWithBool:NO]] retain];
    }
    
	// sort them by date
	recents = [[recents sortedArrayUsingComparator: ^(id mo1, id mo2) {
		return (NSComparisonResult)[[mo2 date] compare:[mo1 date]]; // recent first
	}] retain];
	favorites = [[favorites sortedArrayUsingComparator: ^(id mo1, id mo2) {
		return (NSComparisonResult)[[mo2 date] compare:[mo1 date]]; // recent first
	}] retain];
	
	recents = [[NSMutableArray arrayWithArray:recents] retain];
	favorites = [[NSMutableArray arrayWithArray:favorites] retain];
	
	favoritesRows = [favorites count] == 0 ? 1 : [favorites count];
	recentsRows = [recents count] == 0 ? 1 : [recents count];
    
    [searchDao release];
}




/**
 * Push the Advanced Search screen.
 */
-(IBAction) pushAdvancedSearch {
	[self.navigationController pushViewController:advancedSearchTVC animated:YES];
}




- (void)notify:(NSNotification *)notification {
	NSIndexPath *sourceIndexPath = [[notification userInfo] objectForKey:@"CellCheckToggled"]; 
	
	NSMutableArray *sourceArray = [sourceIndexPath section]==0 ? favorites : recents;
	NSMutableArray *targetArray = [sourceIndexPath section]==0 ? recents : favorites;
	
	// update core data
	SearchMo *mo = [sourceArray objectAtIndex:[sourceIndexPath row]];
	mo.favorite = [NSNumber numberWithInt:([sourceIndexPath section]==0?0:1)];
	mo.date = [NSDate date];
	SearchDao *searchDao = [SearchDao new];
    [searchDao save];
    [searchDao release];
	
	//debug(@"clicked on row=%d, section=%d, label=%@", indexPath.row, indexPath.section, [mo cellLabel]);
	
	[tableView beginUpdates];
	
	//debug(@"clicked cell was %@, element is %@", ((StyleSubtitleControlTVCell*)[tableView cellForRowAtIndexPath:indexPath]).headerText, [[from objectAtIndex:indexPath.row] shortDescribe]);
	//[from removeObjectAtIndex:indexPath.row];
	
	UITableViewRowAnimation animationDelete = [sourceIndexPath section]==0 ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
	UITableViewRowAnimation animationInsert = [sourceIndexPath section]==0 ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
	
	// delete from source section
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:sourceIndexPath] withRowAnimation:animationDelete];
	[sourceArray removeObjectAtIndex:sourceIndexPath.row];
	if ([sourceIndexPath section]==0) favoritesRows--; else recentsRows--;
	debug(@"DELETE ROW from source. favorites=%d recents=%d", favoritesRows, recentsRows);

	// if source section is empty
	if ([sourceArray count]==0){
		// insert help cell
		NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:[sourceIndexPath section]];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] 
						 withRowAnimation:UITableViewRowAnimationFade];
		if ([sourceIndexPath section]==0) favoritesRows++; else recentsRows++;
		debug(@"INSERTING HELP ROW at source. favorites=%d recents=%d", favoritesRows, recentsRows);
	}
	
	// indexPath for insertion
	NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:0 inSection:([sourceIndexPath section]==0?1:0)];

	// if target section is empty
	if ([targetArray count]==0){
		if ([self tableView:self.tableView numberOfRowsInSection:[targetIndexPath section]==1]){
			// then, there should be a help cell that we need to delete
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:targetIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			if ([targetIndexPath section]==0) favoritesRows--; else recentsRows--;
	        debug(@"DELETE HELP ROW at target. favorites=%d recents=%d", favoritesRows, recentsRows);
		} else {
			debug(@"uhm nothing to delete");
		}
	}
	
	// insert row
	[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:targetIndexPath] withRowAnimation:animationInsert];
	[targetArray insertObject:mo atIndex:0];
	if ([targetIndexPath section]==0) favoritesRows++; else recentsRows++;
	debug(@"INSERTING ROW at target. favorites=%d recents=%d", favoritesRows, recentsRows);
	
	/*
	// if section is empty after delete
	if ([self tableView:self.tableView numberOfRowsInSection:[sourceIndexPath section]==0]){
		// add a cell with a help message
		NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:[sourceIndexPath section]];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] 
						 withRowAnimation:UITableViewRowAnimationFade];
		if ([sourceIndexPath section]==0) favoritesRows++; else recentsRows++;
		debug(@"INSERTING HELP ROW at target. favorites=%d recents=%d", favoritesRows, recentsRows);
	}
	*/
	
	[tableView endUpdates];
	
	[self refreshDataOnCheckbox];
	
	//[self refreshTableData];
	//[self.tableView reloadData];
}





/**
 * Iterate on all rows setting correct data on ToggleImageControl.
 * This is needed after inserting/deleting rows.
 */
-(void) refreshDataOnCheckbox {
	int sections = [tableView numberOfSections];
	for (int s=0; s<sections; s++) {
		
		// for each section
		int rows = [tableView numberOfRowsInSection:s];
		for (int r=0; r<rows; r++) {
			
			// for each row
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
			id cell = [tableView cellForRowAtIndexPath:indexPath];
			if ([cell isMemberOfClass:[StyleSubtitleControlTVCell class]]){
				// update the checkbox control
				StyleSubtitleControlTVCell *c = (StyleSubtitleControlTVCell *)cell;
				c.toggleImageControl.selected = s==0 ? TRUE : FALSE;
				c.toggleImageControl.indexPath = indexPath;
				//debug(@"cell %@ is now on section=%d row=%d", c.headerText, [indexPath section], [indexPath row]);
			}
		}
	}
}




# pragma mark -
# pragma mark UISearchBarDelegate




/** 
 * Should we begin editing? 
 * Called when we start typing on the bar.
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	// show the cancel button 
	[searchBar setShowsCancelButton:YES animated:YES];
	        
    // get the cancel button
    UIButton *cancelButton = nil;
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            cancelButton = (UIButton*)subView;
            break;
        }
    }
    
    SEL selector = @selector(setTintColor:);
    if (cancelButton!=nil && [cancelButton respondsToSelector:selector] == YES) {
        UIImage *imgUnsel = [Themes getCachedImage:PNG_SEARCH_CANCEL_UNSEL];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:imgUnsel];
        [imgView setFrame:CGRectMake(0, 0, imgUnsel.size.width, imgUnsel.size.height)];
        [cancelButton performSelector:@selector(addSubview:) withObject:imgView];
        [imgView autorelease];
    }
	
	return YES;
}




/** 
 * Should we stop editing? 
 * Called when we press Search on the keyboard.
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	
	// hide the cancel button
	[searchBar setShowsCancelButton:NO animated:YES];
	
    // onethread
    [self runQuery:searchBar];
    
    //[NSThread detachNewThreadSelector:@selector(runQuery:) toTarget:self withObject:searchBar]; 
	
	return YES;
}


-(void)runQuery:(UISearchBar*)searchBar {
	
	// trim white space
	NSString *query = [searchBar text];
	query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if ([query length]>0){
		debug(@"\n");
		debug(@"RUNNING SEARCH FROM SEARCH BAR");
		
		Query *query = [Query new];
		query.keywords = [searchBar text];
		
	    SearchManager *searchManager = [[SearchManager new] init];
		SearchMo *searchMo = [searchManager runJsonQuery:query];
        
        if (searchMo==nil) {
            // The query only fails when there is no connectivity.
            // Nothing else to do. HttpDownload should have already spawned a warning hud.
            warn(@"Query failed. Nothing else to do");
            [query release];
            [searchManager release];
            return;
        }
        
		searchMo.keywords = query.keywords;
		
		SearchDao *searchDao = [[SearchDao alloc] initWithManager:[CoreDataPersistentManager sharedInstance]];
        [searchDao save];
        
        [searchDao release];
        [searchManager release];
        [query release];
        
	    [self refreshTableData];      // refresh data (from Core Data to local arrays)
		[self.tableView reloadData];  // reload data
		
		// pass it to the next controller
		searchJobsTVC.searchMo = searchMo;
		//debug(@"Passing to the next controller: %@", [searchMo describe]);
		
		// push the next screen
		debug(@"\n"); 
		debug(@"PUSHING Results Table Controller \n");
		
	    [self performSelectorOnMainThread:@selector(pushResults) withObject:nil waitUntilDone:false];
		
		// TODO: should be cell insertion not reloading all data	
		
	    searchBar.text=@""; // clear search bar
	}
}




-(void)pushResults {
	[self.navigationController pushViewController:searchJobsTVC animated:YES];
}




/** 
 * Handle tapping the search button. 
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}




/** 
 * Handle tapping the cancel button. 
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
}




# pragma mark -
# pragma mark UITableViewDelegate




/**
 * Handle selecting a row from the table.
 * Pass the selected SearchMo to the next screen.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	
	// get the selected object
	SearchMo *searchMo = section==1 ? [recents objectAtIndex:row] : [favorites objectAtIndex:row];
	
	// pass it to the next controller
	searchJobsTVC.searchMo = searchMo;
	
	// push the next screen
	debug(@"PUSHING job results (SearchJobsTVC class)");
	[self.navigationController pushViewController:searchJobsTVC animated:YES];
}




# pragma mark -
# pragma mark UITableViewDataSource




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}




/*
-(void) tableView:(UITableView*) tv moveRowAtIndexPath:(NSIndexPath*) oldPath toIndexPath:(NSIndexPath*) newPath {
	
	// get the mo we are moving
	SearchMo *searchMo = [oldPath section]==1 ? [recents objectAtIndex:[oldPath row]] : [favorites objectAtIndex:[oldPath row]];
    // toggle the favorite flag
	BOOL isFavorite = [searchMo.favorite intValue]==1;
    searchMo.favorite = [NSNumber numberWithBool:!isFavorite];
	
	[[SearchDao new] save];
	[self refreshTableData];
	[tv reloadData];
	
	debug(@"got a %@", [searchMo shortDescribe]);
}
*/



- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}




/**
 * @return section header
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section==0 ? localize(@"section.title.favorites") : localize(@"section.title.recents");
}




- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}




/**
 * @return number of sections of the table
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}




/** 
 * @return number of rows in a given section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*
	// if section is 0 and there are no favorites OR section is 1 and there are no recents
	BOOL needsHelpCell = (section==0 && [favorites count]==0) || (section==1 && [recents count]==0);
	// return help cell or the number of favorites/recents
    int rows = needsHelpCell ? 1 : (section==0 ? [favorites count] : [recents count]);
	debug(@"RETURNING %d cells for section %d", rows, section);
	*/
	//int rows = (section==0 ? [favorites count] : [recents count]);
	/*
	if (rows==0){
		[self.tableView beginUpdates];
	    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:section]]
					 	      withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView endUpdates];
		rows=1;
	}
	*/
	return section==0 ? favoritesRows : recentsRows;
}
	/*
	// if section is favorites AND there are no favorites AND there are recents
	// then we return 1 to show a placeholder cell with a help tip
	// otherwise we show the number of cells for whatever section we are in
	BOOL needToShowHelpCell = (section==0 && [favorites count]==0 && [recents count]>0)
	                          || (section==1 && [favorites count]>0 && [recents count]==0); 
	int rows = needToShowHelpCell ? 1 : section==0 ? [favorites count] : [recents count];
    return rows;

//	return section==0 ? [favorites count] : [recents count]; 
}
*/



/**
 * Return a cell for insertion at the given place.
 */
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];
	int section = [indexPath section];
	
	// if the section is empty, return a cell with a help message
	{
		static NSString *cellIdHelp = @"HelpCell";
		// favorites "help cell" if requested cell is on section 0 but favorites is empty
		if ((section==0) && ([favorites count]==0)){
			StyleSubtitleTVCell *cell = (StyleSubtitleTVCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdHelp];
			if (cell == nil) {
				cell = [[[StyleSubtitleTVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdHelp] autorelease];
			}
			// return placeholder cell for favorites
			cell.detailText = localize(@"empty.favorites.cell");
			cell.userInteractionEnabled = FALSE;
			return cell;
		}
		// recents "help cell" if requested cell is on section 1 but recents is empty
		if ((section==1) && ([recents count]==0)){
			StyleSubtitleTVCell *cell = (StyleSubtitleTVCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdHelp];
			if (cell == nil) {
				cell = [[[StyleSubtitleTVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdHelp] autorelease];
			}
			// return placeholder cell for recents
			cell.detailText = localize(@"empty.recents.cell");
			cell.userInteractionEnabled = FALSE;
			return cell;
		}
	}
	
	
    // reuse or create a cell
	static NSString *cellIdSearch = @"Cell";
    StyleSubtitleControlTVCell *cell = (StyleSubtitleControlTVCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdSearch];
    if (cell == nil) {
		cell = [[[StyleSubtitleControlTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdSearch] autorelease];
    }
	
	// set the cell labels
    {
        if ( (section == 0) && (row < [favorites count]) ) {
			// favorites
            SearchMo *searchMo = [favorites objectAtIndex:row];
            cell.detailText = [NSString stringWithFormat:@"%d jobs", [[searchMo jobs] count]];
            cell.headerText = [searchMo cellLabel];
			cell.toggleImageControl.indexPath = indexPath;
			cell.toggleImageControl.selected = TRUE;
			cell.userInteractionEnabled = TRUE;
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//cell.showsReorderControl = NO;
			
        } else if ( (section == 1) && (row < [recents count]) ) {
			// recents
            SearchMo *searchMo = [recents objectAtIndex:row];
            cell.detailText = [NSString stringWithFormat:@"%d jobs", [[searchMo jobs] count]];
            cell.headerText = [searchMo cellLabel];
			//debug(@"### RECENTS s%d r%d is %@", section, row, cell.headerText);
			cell.toggleImageControl.indexPath = indexPath;
			cell.toggleImageControl.selected = FALSE;
			cell.userInteractionEnabled = TRUE;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//cell.showsReorderControl = NO;
            
            // 16 hours = 57600 seconds, 3 hours = 10800 seconds
            double color;
            NSTimeInterval interval = abs([searchMo.date timeIntervalSinceNow]);
            double hours = abs(interval/3600);
            if (hours<3){
                // less than 3 hours = black
                color = 0;
                debug(@"# %@ is %f hours old, color is %f", [searchMo cellLabel], hours, color);
            } else if (hours> 16){
                // more than 16 hours = light gray
                color = 0.2;
                debug(@"### %@ is %f hours old, color is %f", [searchMo cellLabel], hours, color);
            } else {
                // between 3 and 16 hours, color between 0.5 and 1
                color = 1-(0.5 + 0.5 - 0.5 * hours/13); // a minimum of 0.5, plus 0.5 based on the last 13 hours
                debug(@"## %@ is %f hours old, color is %f", [searchMo cellLabel], hours, color);
            }
            cell.headerColor = [UIColor colorWithRed:color green:color blue:color alpha:1.0];
            
        }
    }

    return cell;
}




- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
	// return section separator of 22, or 0 if there is no title
    return [self tableView:tv titleForHeaderInSection:section] != nil ? 22 : 0;
}




- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tv titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil; // nothing to do
    }
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(13, 0, 300, 22);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB(0xFFFFFF);
    label.shadowColor = UIColorFromRGB(0x64696E);
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont systemFontOfSize:16];
    label.text = sectionTitle;
	
    //static UIImage *sectionBg = nil;
    //if (sectionBg==nil) { sectionBg = [Themes getCachedImage:PNG_SECTION_BG]; }
    UIImage *sectionBg = [Themes getCachedImage:PNG_SECTION_BG];
    
	UIImageView *imageView = [[UIImageView alloc] initWithImage:sectionBg];
    [imageView autorelease];
    [imageView addSubview:label];
	
	
    // Create header view and add label as a subview
	/*
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [view autorelease];
    [view addSubview:label];
	 */
	
    return imageView;
}




# pragma mark -
# pragma mark custom UIViewController




- (void)viewDidLoad {
	debug(@"\n");
	debug(@"SEARCHTVC //////////////////////////////////////////////////////////////////////\n");
	[super viewDidLoad];
    
    UIImage *img = [Themes getCachedImage:PNG_BTN_ADVANCED_UNSEL];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [btn setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushAdvancedSearch) forControlEvents:UIControlEventTouchUpInside];
    button.customView = btn;
    
	// remove background of the UISearchBar
	for (UIView *subview in self.sBar.subviews) {
		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
			[subview removeFromSuperview];
			break;
		}
	}
	
	// remove separator
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// load the company logo
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[Themes getCachedImage:PNG_TOP_BAR_TITLE]]; //[UIImage imageNamed:@"jobsket-logo.png"]];
	
	// activate reordering of cells
	//[tableView setEditing:YES animated:YES];
	//tableView.allowsSelectionDuringEditing = YES;
	
	// notification center for notifications sent from ToggleImageControl
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(notify:) name:@"CellCheckToggled" object:nil];
}




- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	debug(@"refresh and repaint")

	// set table background
	UIImage *tableBackground = [[Themes getCachedImage:PNG_TABLE_BG] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	UIImageView *bgView = [[[UIImageView alloc] initWithImage:tableBackground] autorelease];
	self.tableView.backgroundView = bgView;
	
	// reload and repaint
	[self refreshTableData];
	[self.tableView reloadData];
	[[self.tableView layer] setNeedsDisplay];
}




/** 
 * Title of the table.
 */
- (NSString *)title {
    return @"Time as a table";
}




/**
 * Creates the table view.
 */
/*
- (void)loadView {
	// is this code being run?
	
    if (self.nibName) {
		// load the table view from the NIB 
        [super loadView];
        NSAssert(tableView != nil, @"NIB file did not set tableView property.");
        return;
    }
	
	// NIB not found so create a default table
    UITableView *newTableView = [[[UITableView alloc] initWithFrame:CGRectZero
                                                              style:UITableViewStylePlain] autorelease];
    self.view = newTableView;
    self.tableView = newTableView;
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//[self.view setScrollEnabled:NO];  // scrollEnabled is a property of UIScrollView
}
*/


# pragma mark -
# pragma mark custom UITableViewController 

// methods here are just to emulate the behavior of the table controller


/** Change the editable state of the table. */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
}


/** Set the style of the table to UITableViewStylePlain or UITableViewStyleGrouped. */
- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [self initWithNibName:nil bundle:nil])) {
        UITableView *newTableView = [[[UITableView alloc] initWithFrame:CGRectZero
                                                                  style:style] autorelease];
        self.view = newTableView;
        self.tableView = newTableView;
	}	
	return self;
}


/**
 * Get the UITableView outlet.
 */
- (UITableView *)tableView {
    return tableView;
}


/**
 * Set the UITableView outlet.
 */
- (void)setTableView:(UITableView *)newTableView {
    [tableView release];
    tableView = [newTableView retain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
}

# pragma mark -
# pragma mark NSObject


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[recents release];
	[favorites release];
	//[tableView release];
    [super dealloc];
}


@end
