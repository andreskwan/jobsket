
#import "SegControlVC.h"

@implementation SegControlVC

@synthesize btnRefresh, btnFav, btnMap, buttons, delegate, mutuallyExclusiveButtons;


-(void) initButtons {
	self.mutuallyExclusiveButtons = NO;
	
	// set the ivar buttons on the array
    self.buttons = [[NSMutableArray alloc] initWithObjects:btnRefresh, btnFav, btnMap, nil];

	// iterate over all the buttons adding the methods handling the control events
	for (NSUInteger i=0; i<[buttons count]; i++) {
		UIButton *button = [buttons objectAtIndex:i];
		
		// this is done in the nib, but should be redo in code if you want to change with the theme
		// [button setBackgroundImage:segControl-refresh-up   forState:UIControlStateNormal];
		// [button setBackgroundImage:segControl-refresh-down forState:UIControlStateHighlighted];
		// [button setBackgroundImage:segControl-refresh-down forState:UIControlStateSelected];
		
		// don't redraw lighter when highlighted
		button.adjustsImageWhenHighlighted = NO;
		
		// register for touch events
		[button addTarget:self action:@selector(touchDownAction:)     forControlEvents:UIControlEventTouchDown];
		[button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
		[button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchUpOutside];
		[button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragOutside];
		[button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragInside];
	}
}


-(UIButton*) buttonAtIndex:(int) index {
	return [buttons objectAtIndex:index];
}



-(void) dimAllButtonsExcept:(UIButton*)selectedButton {
	for (UIButton* button in buttons) {
		if (button == selectedButton) {
			button.selected = YES;
			button.highlighted = button.selected ? NO : YES;
		} else {
			button.selected = NO;
			button.highlighted = NO;
		}
	}
}


- (void)touchDownAction:(UIButton*)button {
	if (mutuallyExclusiveButtons) [self dimAllButtonsExcept:button];
	if ([delegate respondsToSelector:@selector(touchDownAtSegmentIndex:)])
		[delegate touchDownAtSegmentIndex:[buttons indexOfObject:button]];
}


- (void)touchUpInsideAction:(UIButton*)button {
	if (mutuallyExclusiveButtons) [self dimAllButtonsExcept:button];
	if ([delegate respondsToSelector:@selector(touchUpInsideSegmentIndex:)])
		[delegate touchUpInsideSegmentIndex:[buttons indexOfObject:button]];
}


- (void)otherTouchesAction:(UIButton*)button {
	if (mutuallyExclusiveButtons) [self dimAllButtonsExcept:button];
	if ([delegate respondsToSelector:@selector(otherTouchesInsideSegmentIndex:)])
		[delegate otherTouchesInsideSegmentIndex:[buttons indexOfObject:button]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad {
    [super viewDidLoad];
	[self initButtons];
}


- (void)dealloc {
    [super dealloc];
	[buttons release];
	[btnRefresh release]; 
	[btnFav release]; 
	[btnMap release]; 
}


@end
