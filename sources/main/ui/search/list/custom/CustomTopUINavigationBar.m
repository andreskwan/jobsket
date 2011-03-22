
#import "CustomTopUINavigationBar.h"

@implementation CustomTopUINavigationBar


- (void)drawRect:(CGRect)rect {
	// background
	UIImage *img  = [Themes getCachedImage:PNG_TOP_BAR_BG];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
