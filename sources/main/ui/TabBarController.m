
#import "TabBarController.h"

@implementation TabBarController

@synthesize theTabBar;


-(void) viewDidLoad {
    
    // initialize tab names
    NSArray *items = [self.theTabBar items];
    UITabBarItem *searchTab    = (UITabBarItem *)[items objectAtIndex:0];
    UITabBarItem *favoritesTab = (UITabBarItem *)[items objectAtIndex:1];
    UITabBarItem *accountTab   = (UITabBarItem *)[items objectAtIndex:2];
    searchTab.title = localize(@"tab.search.title");
    favoritesTab.title = localize(@"tab.favorites.title");
    accountTab.title = localize(@"tab.account.title");
    
    [super viewDidLoad];
}


@end
