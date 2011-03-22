
#import "CustomTVCell.h"
#import "CellDrawing.h"

@interface StyleSubtitleTVCell : CustomTVCell {
	NSString *headerText;
	NSString *detailText;
	UIFont *firstTextFont;
	UIFont *lastTextFont;
}

@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) UIFont *firstTextFont;
@property (nonatomic, copy) UIFont *lastTextFont;


/**
 * @parameter selected True if the cell is selected.
 */
- (void)drawBackground:(CGRect)rect selected:(BOOL)selected;


@end
