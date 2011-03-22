
#import <Foundation/Foundation.h>

@interface ToggleImageControl : UIControl {
	
	UIImageView *imageView;
	UIImage *normalImage;    // image when control is not selected
	UIImage *selectedImage;  // image when control is selected

	BOOL selected;  // Is the control selected?
	
	NSIndexPath *indexPath; // used to send notifications on click
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *selectedImage;

-(void) setSelected:(BOOL) selected;

@end
