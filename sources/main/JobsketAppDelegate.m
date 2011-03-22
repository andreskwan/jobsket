
#import "JobsketAppDelegate.h"


@implementation JobsketAppDelegate

@synthesize window, tabBarController;
@synthesize tabBarArrow;
@synthesize hud;


/** Warn when connectivity is lost. */
-(void) hudWarningNoConnection {
    ATMHud *myHud = [[[ATMHud alloc] initWithDelegate:self] autorelease];
    //UIImage *icon = [UIImage imageNamed:@"ico-warning"];
    //[hud setImage:icon];
    [myHud setCaption:localize(@"hud.warning.no.connection")];
    [self.window addSubview:myHud.view];
    [myHud show];
    [myHud hideAfter:2.0];
}


#pragma mark -
#pragma mark Splash animation


- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[splashView removeFromSuperview];
	[splashView release];
}


-(void)animateSplashView {
	// animate Default.png
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	splashView.frame = CGRectMake(-60, -85, 440, 635);
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Arrow tab indicator


/** Add the arrow indicator as a subview of the window. */
- (void) addTabBarArrow 
{
	UIImage* tabBarArrowImage = [UIImage imageNamed:@"tabBarIndicator.png"];
	self.tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
	
	// To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
	CGFloat verticalLocation = self.window.frame.size.height - tabBarController.tabBar.frame.size.height - tabBarArrowImage.size.height + 2;
	tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
	
	[self.window addSubview:tabBarArrow];
}


/** Return the horizontal position for a given tab. */
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
	// A single tab item's width is the entire width of the tab bar divided by number of items
	CGFloat tabItemWidth = tabBarController.tabBar.frame.size.width / tabBarController.tabBar.items.count;
	
	// A half width is tabItemWidth divided by 2 minus half the width of the arrow
	CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
	
	// The horizontal location is the index times the width plus a half width
	return (tabIndex * tabItemWidth) + halfTabItemWidth;
}


/** 
 * Animate the arrow towards the new position. 
 * This is a UITabBarControllerDelegate method.
 */
- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	CGRect frame = tabBarArrow.frame;
	frame.origin.x = [self horizontalLocationFor:tabBarController.selectedIndex];
	tabBarArrow.frame = frame;
	[UIView commitAnimations];  
	
}


#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    	

    // warn if zombies are enabled
    warn(@"Running %@ zombies", getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled") ? @"WITH" : @"WITHOUT");
    
    // notification center for missing connectivity
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(hudWarningNoConnection) 
                                                 name:@"hudWarningNoConnection" 
                                               object:nil];
    
	tabBarController.delegate = self;
    [window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
    
    // add tab indicator
	[self addTabBarArrow];
    
    // splash animation
	[self animateSplashView];

	// remove SearchMo objects older than 16 hours
    debug(@"removing older than 16 hours...");
    NSDate *date = [NSDate dateWithHoursBeforeNow:16];
    SearchDao *searchDao = [SearchDao new];
    NSArray *recents = [searchDao searchNotFavoritesOlderThan:date];
    for (SearchMo *mo in recents) {
        debug(@"removing mo: %@", mo.url);
        [searchDao remove:mo];
    }
    [searchDao release];
    
    // refresh the list of companies all at once, so we don't need to do it later for each job found
	Housekeeping *hk = [[[Housekeeping alloc]init] autorelease];
    [hk refreshCompanies];

	// retry pending share requests
    [SHK flushOfflineQueue];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}


#pragma mark -
#pragma mark Memory management


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


- (void)dealloc {
    [hud release];
    [tabBarArrow release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

