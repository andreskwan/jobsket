
#import "SearchJobsDetailTVC.h"


#import <UIKit/UIKit.h>
#import "JobMo.h"
#import "CompanyMo.h"
#import "BundleLookup.h"
#import "JobDao.h"
#import "CoreDataPersistentManager.h"
#import "Themes.h"
#import "SegControlVC.h"
#import "FavoritesDetailMapVC.h"
#import "UIImage+Extension.h"
#import "SearchUINavigationController.h"
#import "FavoritesUINavigationController.h"
//sharekit #import "SHK.h"
//#import "FavoritesListTVC.h"


@interface FavoritesDetailTVC : UIViewController <UITableViewDelegate, UITableViewDataSource, SegControlDelegate> {

    
    UINavigationController *navController; // reference to the nav controller for push/pop
	FavoritesDetailMapVC *favoritesDetailMapVC; // map view controller
	UITableView *tableView;
	JobMo *jobMo; // job this table is displaying
	
	UIView *headerView;    // view for the first half of the job detail
	UILabel *lvDate;       //   - date top right
	UILabel *ltJobTitle;   //   - label value job title
	UILabel *ltCompany;    //   - label title company
	UILabel *ltExperience; //   - label title experience
	UILabel *ltLocation;   //   - label title location
	UILabel *ltCategory;   //   - label title category
	UILabel *lvCompany;    //   - label value company 
	UILabel *lvExperience; //   - label value experience
	UILabel *lvLocation;   //   - label value location
	UILabel *lvCategory;   //   - label value category
	
	UILabel *nameLabel;         // ? 
	UINavigationBar *navBar;    // ? 
    UIBarButtonItem *favButton; // ?
	
	SegControlVC *segControl; // Custom segmented control
	UIButton *btnFav;         //   - favorite button
	UIImage *favoriteOn;      //   - image for state on
	UIImage *favoriteOff;     //   - image for state off
	
	NSArray *labels; // value for the label titles
	NSArray *values; // value for the label values
	
	UIWindow *parentWindow;
	
	UITabBarController *uiTabBarController;
	JobsketAppDelegate *delegate;

}



@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet FavoritesDetailMapVC *favoritesDetailMapVC;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) JobMo *jobMo;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *ltJobTitle;
@property (nonatomic, retain) IBOutlet UILabel *ltCompany;
@property (nonatomic, retain) IBOutlet UILabel *ltExperience;
@property (nonatomic, retain) IBOutlet UILabel *ltLocation;
@property (nonatomic, retain) IBOutlet UILabel *ltCategory;
@property (nonatomic, retain) IBOutlet UILabel *lvCompany;
@property (nonatomic, retain) IBOutlet UILabel *lvExperience;
@property (nonatomic, retain) IBOutlet UILabel *lvLocation;
@property (nonatomic, retain) IBOutlet UILabel *lvCategory;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIBarButtonItem *favButton;

@property (nonatomic, retain) IBOutlet SegControlVC *segControl;
@property (nonatomic, retain) UIImage *favoriteOn;
@property (nonatomic, retain) UIImage *favoriteOff;

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

@property (nonatomic, retain) NSArray *labels;
@property (nonatomic, retain) NSArray *values;

@property (nonatomic, retain) IBOutlet UIWindow *parentWindow;

@property (nonatomic, retain) IBOutlet UITabBarController *uiTabBarController;
@property (nonatomic, retain) IBOutlet JobsketAppDelegate *delegate;


- (NSString*) valueForRow:(NSIndexPath *)indexPath;
- (NSString*) labelForRow:(NSIndexPath *)indexPath;
- (BOOL) isMultiline:(NSIndexPath*) indexPath;
- (void)share;
- (void) hidetabbar:(BOOL)hiddenTabBar;
- (void) hideArrow;


@end

