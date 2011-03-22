
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "SearchJobsDetailTVC.h"
#import "HtmlToJson.h"
#import "HttpDownload.h"
#import "JobMo.h"
#import "StyleSubtitleTVCell.h"
#import "JsonToMo.h"
#import "SearchMapVC.h"
#import "SearchMo.h"
#import "Themes.h"
#import "JsonMoBuilder.h"


@interface SearchJobsTVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	SearchJobsDetailTVC *jobDetail;
	SearchMapVC *jobMap;
	
    UINavigationController *navController;
	UITableView *tableView;
	
	UISegmentedControl *segmentedControl;
	UILabel *statusLabel;
	UIView *labelBackground;
	
	SearchMo *searchMo;
	NSArray *jobs;
	
	UIImageView *fakeSectionHeader;

	JobsketAppDelegate *delegate;
	
	UITabBarController *uiTabBarController;
}

@property (nonatomic, retain) IBOutlet UIImageView *fakeSectionHeader;

@property (nonatomic, retain) IBOutlet SearchJobsDetailTVC *jobDetail;
@property (nonatomic, retain) IBOutlet SearchMapVC *jobMap;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIView *labelBackground;

@property (nonatomic, retain) SearchMo *searchMo;
@property (nonatomic, retain) NSArray *jobs;

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
