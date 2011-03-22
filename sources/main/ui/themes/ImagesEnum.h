
#import <UIKit/UIKit.h>

/**
 * Each value in this file is a graphic resource: image, font, or color.
 */
@protocol ImagesEnum

// XCode doesn't refactor enums. If you try, only this file will be modified, 
// and then you'll have to rename manually each compiler error.

// The values to these keys are set in the Themes class.

enum Images {
	
    PNG_BTN_ADVANCED_SEL,
    PNG_BTN_ADVANCED_UNSEL,
    
    PNG_SEARCH_CANCEL_SEL,
    PNG_SEARCH_CANCEL_UNSEL,
    
	// Background for UINavigationBar, on several screens of the app.
	// This background is set in CustomTopUINavigationBar.drawRect.
	// Each bar of the application needs to have its class changed in UIBuilder 
	// from UINavigationBar to CustomTopUINavigationBar.
	PNG_TOP_BAR_BG,
	
	// Jobsket logo in UINavigationBar, 1st screen of the Search tab.
	// Set as UIViewController.navigationItem.titleView in SearchListTVC.viewLoad:
	PNG_TOP_BAR_TITLE,
	
	// Background of the UISearchBar, 1st screen of the Search tab.
	// Set as background of the underlying bar in CustomSearchUINavigationBar.drawRect:
	PNG_SBAR_BG,
	
	// Color for the buttons in the UISearchBar, 1st screen of the Search tab.
	// Set in CustomSearchUINavigationBar.drawRect:
	HEXCOLOR_SBAR_BUTTON,
	
	// Background of the table. This is visible when there are not enough cells to fill the table.
	// Set in SearchListTVC.viewWillAppear:
	PNG_TABLE_BG,
	
	// Background of the section header. Set as SearchListTVC.tableView:viewForHeaderInSection:
	// Check the same method if you want to change the section height, and the font/color/shadow of the text.
	PNG_SECTION_BG,
	
	// Background of the cell.
	// Not currently used. We paint in StyleSubtitleControlTVCell instead, using Core Graphics.
	PNG_CELL_BG,
	
	// Color for the UISegmentedControl. Set in SearchJobsTVC.viewDidLoad.
	// This color is modified (I don't know exactly how) by Core Graphics.
	HEXCOLOR_SEGMENTED_CONTROL,
	
	// Favorite button in the top bar right. Set in SearchJobsDetailTVC.viewDidLoad.
	// If you change the dimensions of the button, update favBtn.frame size in viewDidLoad.
	PNG_TOP_BAR_FAV_BTN,        // empty button
	PNG_TOP_BAR_FAV_BTN_STAR,   // full star
	PNG_TOP_BAR_FAV_BTN_SHALLOW, // shallow star
	
	// Search button
	PNG_TOP_BAR_BTN,    // empty button
	
    // Back button. Set in SearchJobsTVC.viewDidLoad.
	PNG_TOP_BAR_BACK,
    PNG_TOP_BAR_SEARCH,
    PNG_TOP_BAR_FAVORITES,
    PNG_TOP_BAR_JOBS,

	// job detail table ////////////////////////////////////////////////////////////////////////////
	
	// background for the cells of the job detail table
	// Set in SearchJobsDetailTVC.tableView:cellForRowAtIndexPath:
	PNG_TABLE_JOBDETAIL_BG,

	// font for the name of the job
	FONT_JOBDETAIL_TITLE,
	
	// font for the headers of the job detail table (usually "AmericanTypewriter")
	FONT_JOBDETAIL_CELLTITLE,
	
	// font for the content of the job detail table (usually "VagRoundedStd-Light")
	FONT_JOBDETAIL_CELLCONTENT,
	
	// wood background for the job detail table
	PNG_TABLE_WOOD_BG,
	
	// cell separator for the job detail table
	PNG_TABLE_SEPARATOR,
	
	// color for the cell titles (company, location, requirements, ...)
	HEXCOLOR_JOBDETAIL_CELL_TITLE,

    FONT_JOBDETAIL_PUBLISHED,
    

	// search results //////////////////////////////////////////////////////////////////////////////
	
	// map button
	PNG_BTN_MAP_UP, 
	PNG_BTN_MAP_DOWN,
	
    FONT_SEARCH_CELLDETAIL,
    FONT_SEARCH_CELLHEADER,
    
    // back button at search > results > detail > map
    PNG_TOP_BAR_DETAIL,
    
    
    // icons ///////////////////////////////////////////////////////////////////////////////////////
    
    PNG_ICO_WARNING,
    PNG_ICO_RADAR,

    
    // advanced search /////////////////////////////////////////////////////////////////////////////
    
    HEXCOLOR_ADVANCEDSEARCH_BUTTON_FG,
    HEXCOLOR_ADVANCEDSEARCH_BUTTON_BG,
    FONT_ADVANCEDSEARCH_BUTTON
	
};

@end
