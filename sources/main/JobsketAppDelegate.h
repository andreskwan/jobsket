
#import <UIKit/UIKit.h>
#import "Housekeeping.h"
#import "Themes.h"
#import "NSDate+Erica.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "SHK.h"


@interface JobsketAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ATMHudDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIImageView *splashView;
	UIImageView* tabBarArrow;
    ATMHud *hud;
}

@property (nonatomic, retain) ATMHud *hud;
@property (nonatomic, retain) UIImageView* tabBarArrow;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void)animateSplashView;
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void) addTabBarArrow;
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController;

-(void) hudWarningNoConnection;

@end