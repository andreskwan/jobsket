
#import <UIKit/UIKit.h>
#import "GenericPickerView.h"
#import "SearchJobsTVC.h"
#import "PickersData.h"
#import "SalaryPickerView.h"
#import "Query.h"
#import "SearchManager.h"
#import "PFTintedButton.h"
#import "ExperiencePickerView.h"


/**
 * Advanced Search.
 *
 * You can access this search clicking on "..." in the first screen.
 */
@interface SearchAdvancedTVC : UIViewController 
    < UITableViewDelegate, 
      UITableViewDataSource, 
	  UIActionSheetDelegate, 
      UITextFieldDelegate
    > 
{
	
	UITableView *tableView;
	SearchJobsTVC *searchJobsTVC;

	PFTintedButton *clearButton;
    PFTintedButton *searchButton;
    
@private

	/** Stores a reference to the UITextField and the pickers. */
	NSMutableDictionary *pickersDict;
	
	/** Keys of the dictionary above in presentation order. */
	NSArray *pickersDictKeys;
	
	/* Data to show on the table for fields other than UITextField.
	 * This is to remember the old values when someone changes the value on a picker
	 * but clicks cancel afterwards.
	 */
	//NSMutableArray *tableValues;
}

@property (nonatomic, retain) IBOutlet PFTintedButton *clearButton;
@property (nonatomic, retain) IBOutlet PFTintedButton *searchButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet SearchJobsTVC *searchJobsTVC;
//@property (nonatomic, retain) UITextField *textField;


-(IBAction) handleSearch;
-(IBAction) handleClear;


@end
