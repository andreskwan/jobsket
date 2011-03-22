
#import "CustomSearchUINavigationBar.h"

@implementation CustomSearchUINavigationBar


/**
 *  Overrides drawing of the bar to allow a change of color or texture.
 */
- (void)drawRect:(CGRect)rect {
	
	// use an image as background (alternative to using a background color)
	UIImage *img  = [Themes getCachedImage:PNG_SBAR_BG];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	 
	// button color
	self.tintColor = [Themes getColor:HEXCOLOR_SBAR_BUTTON]; 
}


@end
