
#import "StyleSubtitleControlTVCell.h"

@implementation StyleSubtitleControlTVCell

@synthesize headerText, detailText, headerFont, detailFont;
@synthesize toggleImageControl;
@synthesize headerColor;


+ (void)initialize {
    if (self == [StyleSubtitleControlTVCell class]) {
		// load small graphics that you can keep in memory
    }
}


// custom setter to call setNeedsDisplay
- (void)setHeaderText:(NSString *)s {
    [headerText release];
    headerText = [s copy];
    [self setNeedsDisplay];
}


// custom setter to call setNeedsDisplay
- (void)setDetailText:(NSString *)s {
    [detailText release];
    detailText = [s copy];
    [self setNeedsDisplay];
}


/**
 * Draws the content of the cell.
 */ 
- (void)drawContentView:(CGRect)rect {

	// toggle control
	[self addSubview:toggleImageControl];
	
	// draw background
	[self drawBackground:rect selected:self.selected];
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:[Themes getCachedImage:PNG_CELL_BG]];
	//self.backgroundView = imageView;
	
	// dimensions of the box containing the header label
	int x = 10 + toggleImageControl.frame.size.width; // margin plus the UIControl
	int y = 3; // margin
	int width = 320 - x - 28; // screen width minus origin x, and 28 less for the hmm arrow thingy
    int height = 22; // harcoded
	
    // bit of a hack, if headerColor has value we use that, otherwise we use black color
    UIColor *hColor = self.headerColor==nil ? [UIColor blackColor] : self.headerColor;
    
	[(self.selected ? [UIColor whiteColor] : hColor) set];
	CGRect headerBox = CGRectMake(x, y, width, height);
	CGSize headerSize = [headerText drawInRect:(CGRect)headerBox withFont:headerFont lineBreakMode:UILineBreakModeTailTruncation];
	
	y = y + headerSize.height;

	[(self.selected ? [UIColor whiteColor] : [UIColor grayColor]) set];
	CGRect detailBox = CGRectMake(x, y, width, height);
    [detailText drawInRect:(CGRect)detailBox withFont:detailFont lineBreakMode:UILineBreakModeTailTruncation];
}


/** 
 * Draws the background of the cell. 
 * Called from drawContentView:.
 */
- (void)drawBackground:(CGRect)rect selected:(BOOL)selected {
	
	CGColorRef topColor;
	CGColorRef bottomColor;
	{
		if (selected) {
			topColor = UIColorFromRGB(0x058CF5).CGColor;    // celeste blue 058CF5
			bottomColor = UIColorFromRGB(0x0059F0).CGColor; // blue 0059F0
			//bottomColor = UIColorFromRGB(0xFF0000).CGColor;
		} else {
			topColor = UIColorFromRGB(0xFFFFFF).CGColor;    // white
			bottomColor = UIColorFromRGB(0xF0F0F0).CGColor; // light gray
		}
	}
	
    CGRect cellRect = self.bounds;
	
	CGContextRef context = UIGraphicsGetCurrentContext();	

    // Fill with gradient
    drawLinearGradient(context, cellRect, topColor, bottomColor);
   
    // Add white 1 px stroke around the cell
    CGRect strokeRect = cellRect;
	strokeRect.size.width += 1; // push the right side beyond the frame
    strokeRect = rectFor1PxStroke(strokeRect);
	CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xFFFFFF).CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
	
    // Add separator
	CGColorRef separatorColor = UIColorFromRGB(0xD0D0D0).CGColor;
    CGPoint startPoint = CGPointMake(cellRect.origin.x, cellRect.origin.y + cellRect.size.height-1);
    CGPoint endPoint = CGPointMake(cellRect.origin.x + cellRect.size.width - 1, cellRect.origin.y + cellRect.size.height-1);
    draw1PxStroke(context, startPoint, endPoint, separatorColor);
    
}


# pragma mark -
# pragma mark UITableViewCell


/**
 * Use this to initialize the cell in tableView:cellForRowAtIndexPath:
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier { 
	// configure fonts
	self.headerFont = [Themes getFont:FONT_SEARCH_CELLHEADER];
	self.detailFont = [Themes getFont:FONT_SEARCH_CELLDETAIL];
	
	// add a checkbox to the left of the frame
	CGRect controlFrame = CGRectMake(5.0, 10.0, 30.0, 30.0); // x,y,width,height
	toggleImageControl = [[ToggleImageControl alloc] initWithFrame:controlFrame];
	
	// the superclass adds a custom UIView with an overriden drawRect: 
	// method which delegates to the drawContentView: of this class
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];	
}


# pragma mark -
# pragma mark NSObject

- (void)dealloc {
    [self.headerText release], self.headerText=nil;
    [self.detailText release], self.detailText=nil;
    if (self.headerColor!=nil) [self.headerColor release];
    [super dealloc];
}

@end
