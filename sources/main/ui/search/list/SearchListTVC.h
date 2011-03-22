
#import <UIKit/UIKit.h>
#import "SearchAdvancedTVC.h"
#import "JobDao.h"
#import "SearchDao.h"
#import "CompanyDao.h"
#import "SearchManager.h"
#import "Query.h"
#import "SearchListTVCell.h"
#import "SearchJobsTVC.h"
#import "StyleSubtitleControlTVCell.h"
#import "CustomUISearchBar.h"
#import "Themes.h"


/**
 * Table with a UISearchBar.
 * This is the first screen of the application.
 * 
 * When the user inputs data on the search bar:
 *   - The data is used as keywords in the Jobsket search URL.
 *   - The page is parsed to Core Data objects.
 *   - A cell appears on the table representing the search.
 *   - Clicking on the cell pushes the result controller.
 * 
 * When the user clicks the advanced search button:
 *   - The Advanced Search screen is pushed.
 *
 */
@interface SearchListTVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {

	int favoritesRows;
	int recentsRows;
	
	/** Table view */
	UITableView *tableView;
	
	/** Search Bar */
	CustomUISearchBar *sBar;
	
	/** Advanced search button */
	UIBarButtonItem *button;
	
	/* Table view controller for the Advanced Search screen.
	 * This gets pushed clicking on the button of the search bar. */
	SearchAdvancedTVC *advancedSearchTVC;
	
	/* Table view controller for the Results screen. 
	 * This gets pushed clicking on one of the cells. */
	SearchJobsTVC *searchJobsTVC;
	
    /* Recent searches. 
	 * Contains the search objects most recently created. */
	NSMutableArray *recents;
	
	/* Favorite searches. 
	 * Contains the search objects marked as favorites. */
	NSMutableArray *favorites;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet CustomUISearchBar *sBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button;
@property (nonatomic, retain) IBOutlet SearchAdvancedTVC *advancedSearchTVC;
@property (nonatomic, retain) IBOutlet SearchJobsTVC *searchJobsTVC;

-(IBAction) pushAdvancedSearch;
-(void) refreshDataOnCheckbox;
-(void)runQuery:(UISearchBar*)searchBar;

@end

