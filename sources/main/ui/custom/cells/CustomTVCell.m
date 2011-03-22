
#import "CustomTVCell.h"

/** 
 * Custom UIView.
 */
@interface MyTableViewCellView : UIView
@end
@implementation MyTableViewCellView
- (void)drawRect:(CGRect)rect {
    [(CustomTVCell *)[self superview] drawContentView:rect];
}

@end



@implementation CustomTVCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) ) {
        contentView = [[MyTableViewCellView alloc] initWithFrame:CGRectZero];
		//[self setFrame:CGRectZero];
        contentView.opaque = YES; // opaque to accelerate rendering
        [self addSubview:contentView];
        [contentView release];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect bounds = [self bounds];
	// commented to have no separator
    //bounds.size.height -= 1; // decrease the height 1 pixels for the separator line
    [contentView setFrame:bounds];
}


- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [contentView setNeedsDisplay];
}


- (void)drawContentView:(CGRect)rect {
    @throw [NSException exceptionWithName:@"OverrideMeException" reason:@"Override this method." userInfo:nil];
}


@end
