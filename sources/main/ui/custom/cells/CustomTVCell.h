
#import <UIKit/UIKit.h>


/** 
 * Subclasses should implement -drawContentView: 
 */
@interface CustomTVCell : UITableViewCell {
	UIView *contentView;
}

- (void)drawContentView:(CGRect)rect;

@end
