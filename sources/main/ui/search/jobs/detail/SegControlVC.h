
#import <UIKit/UIKit.h>


/** Delegate to handle button interactions. */
@protocol SegControlDelegate 
@optional
- (void) touchDownAtSegmentIndex:        (int) index;
- (void) touchUpInsideSegmentIndex:      (int) index;
- (void) otherTouchesInsideSegmentIndex: (int) index;
@end


// TODO: would be better if this class was created using just code instead the UI Builder
//       right now it is not skinnable because graphics are set in the nib instead on the initButtons

@interface SegControlVC : UIViewController {
	UIButton *btnRefresh;	
	UIButton *btnFav;
	UIButton *btnMap;
    NSMutableArray* buttons;
	NSObject <SegControlDelegate> *delegate;
	
	/** When set to YES, it dims all the other buttons when one is pressed. */
	BOOL mutuallyExclusiveButtons;
}

@property (nonatomic, retain) IBOutlet NSObject <SegControlDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UIButton *btnRefresh;	
@property (nonatomic, retain) IBOutlet UIButton *btnFav;
@property (nonatomic, retain) IBOutlet UIButton *btnMap;
@property (nonatomic, retain) NSMutableArray* buttons;
@property (nonatomic, assign) BOOL mutuallyExclusiveButtons; 

-(UIButton*) buttonAtIndex:(int) index;

@end

