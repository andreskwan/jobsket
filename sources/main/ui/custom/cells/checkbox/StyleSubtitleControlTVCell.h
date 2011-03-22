
#import "CustomTVCell.h"
#import "CellDrawing.h"
#import "ToggleImageControl.h"
#import "Themes.h"

@interface StyleSubtitleControlTVCell : CustomTVCell {
	UIColor *headerColor;
	NSString *headerText;
	NSString *detailText;
	UIFont *headerFont;
	UIFont *detailFont;
	
	ToggleImageControl *toggleImageControl;
}

@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, retain) UIFont *headerFont;
@property (nonatomic, retain) UIFont *detailFont;

@property (nonatomic, retain) ToggleImageControl *toggleImageControl;
@property (nonatomic, retain) UIColor *headerColor;


/**
 * @parameter selected True if the cell is selected.
 */
- (void)drawBackground:(CGRect)rect selected:(BOOL)selected;


@end
