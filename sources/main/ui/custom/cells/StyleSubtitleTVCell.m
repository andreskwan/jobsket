
#import "StyleSubtitleTVCell.h"

@implementation StyleSubtitleTVCell

@synthesize headerText, detailText, firstTextFont, lastTextFont;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier { 
	firstTextFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
	lastTextFont = [[UIFont systemFontOfSize:14] retain];
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];	
}


+ (void)initialize {
    if (self == [StyleSubtitleTVCell class]) {
		// load small graphics that you can keep in memory
    }
}


- (void)dealloc {
    [headerText release];
    [detailText release];
    [super dealloc];
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


- (void)drawContentView:(CGRect)rect {
    //CGContextRef context = UIGraphicsGetCurrentContext();
	
    //UIColor *backgroundColor = [UIColor whiteColor];
    UIColor *headerTextColor;
	UIColor *detailTextColor;

    if (self.highlighted) {
        //backgroundColor = [UIColor clearColor];
        headerTextColor = [UIColor whiteColor];
		detailTextColor = [UIColor whiteColor];
        [self drawBackground:rect selected:TRUE];
    } else {
		headerTextColor = [UIColor blackColor];
		detailTextColor = [UIColor grayColor]; // 0.5 white
		[self drawBackground:rect selected:FALSE];
	}

	
	// draw background
    //[backgroundColor set];
    //CGContextFillRect(context, rect); // fill rect with current context color

    CGPoint point = CGPointMake(10, 2); // origin for the headerText
	
    [headerTextColor set]; // set color for the header
	// 292=320-p.x-margin, 22=[headerText drawAtPoint:withFont:].height
	CGRect box = CGRectMake(10, 6, 292, 22); // box to paint the text on
	CGSize size = [headerText drawInRect:(CGRect)box withFont:firstTextFont lineBreakMode:UILineBreakModeTailTruncation];
	
	[detailTextColor set]; // set color for the text detail
    point.y += size.height + 2; // add the height of the previous text
    [detailText drawAtPoint:point withFont:lastTextFont]; // TODO: should draw in a box
}


- (void)drawBackground:(CGRect)rect selected:(BOOL)selected {
	
	//CGColorRef redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    //CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor; 
	//CGColorRef lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
	
	CGColorRef topColor;
	CGColorRef bottomColor;
	{
		if (selected) {
			topColor = UIColorFromRGB(0x058CF5).CGColor;    // celeste blue 058CF5
			bottomColor = UIColorFromRGB(0x0059F0).CGColor; // blue 0059F0
		} else {
			//topColor = UIColorFromRGB(0x00FF00).CGColor;
			topColor = UIColorFromRGB(0xFFFFFF).CGColor;    // white
			//bottomColor = UIColorFromRGB(0xFBFBFB).CGColor; // light gray
			bottomColor = UIColorFromRGB(0xF0F0F0).CGColor; // light gray
		}
	}
	
    CGRect cellRect = self.bounds;
	
	CGContextRef context = UIGraphicsGetCurrentContext();	

    // Fill with gradient
    drawLinearGradient(context, cellRect, topColor, bottomColor);
   
    // Add white 1 px stroke around the cell
    CGRect strokeRect = cellRect;
	//strokeRect.origin.y -=1;
    //strokeRect.size.height -= 1;
	strokeRect.size.width += 1; // push the right side beyond the frame
    strokeRect = rectFor1PxStroke(strokeRect);
    //CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xFFFFFF).CGColor);
	CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xFFFFFF).CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
	
    // Add separator
	CGColorRef separatorColor = UIColorFromRGB(0xD0D0D0).CGColor;
	//CGColorRef separatorColor = UIColorFromRGB(0xD0D0D0).CGColor;
	//CGColorRef separatorColor = UIColorFromRGB(0xFF0000).CGColor; // red
    CGPoint startPoint = CGPointMake(cellRect.origin.x, cellRect.origin.y + cellRect.size.height-1);
    CGPoint endPoint = CGPointMake(cellRect.origin.x + cellRect.size.width - 1, cellRect.origin.y + cellRect.size.height-1);
    draw1PxStroke(context, startPoint, endPoint, separatorColor);
    
}


@end
