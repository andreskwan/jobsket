
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JobDao.h"
#import "FavoritesDetailTVC.h"
#import "SearchJobsDetailTVC.h"
#import "HtmlToJson.h"
#import "HttpDownload.h"
#import "JobMo.h"
#import "StyleSubtitleTVCell.h"
#import "JsonToMo.h"
#import "FavoritesMapVC.h"
#import "SearchMo.h"
#import "FavoritesDetailTVC.h"


@interface FavoritesListTVC  : UIViewController <UITableViewDelegate, UITableViewDataSource> {	
	
	JobDao *dao;
	FavoritesDetailTVC *favoritesDetailTVC;
	
	FavoritesMapVC *favoritesMap;
	
    UINavigationController *navController;
	UITableView *tableView;
	
	UISegmentedControl *segmentedControl;
	UILabel *statusLabel;
	UIView *labelBackground;
	
	UIImageView *fakeSectionHeader;
	
	SearchMo *searchMo;
	NSArray *jobs;
	
	JobsketAppDelegate *delegate;
	
	UITabBarController *uiTabBarController;
}

@property (nonatomic, retain) IBOutlet UIImageView *fakeSectionHeader;

@property (nonatomic, retain) JobDao *jobDao;
@property (nonatomic, retain) IBOutlet FavoritesDetailTVC *favoritesDetailTVC;

@property (nonatomic, retain) IBOutlet FavoritesMapVC *favoritesMapVC;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIView *labelBackground;

@property (nonatomic, retain) SearchMo *searchMo;
@property (nonatomic, retain) NSArray *jobs;

@property(nonatomic, readonly, copy) NSString *nibName;

@property (nonatomic, retain) IBOutlet JobsketAppDelegate *delegate;

@property (nonatomic, retain) IBOutlet UITabBarController *uiTabBarController;


-(IBAction) pushMap;
-(IBAction) sortNewest;
-(IBAction) sortNearest;


/** reload the data for the table. */
-(void) reload;


/** Handle selecting a job from the table. */
-(void) selectJob:(NSIndexPath *)indexPath;


/** Push the job detail controller. */
-(void) pushJobDetail;


@end
