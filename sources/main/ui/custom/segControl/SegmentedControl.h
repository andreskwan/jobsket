
@class SegmentedControl;

@protocol SegmentedControlDelegate

- (UIButton*) buttonFor:(SegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;

@optional
- (void) touchUpInsideSegmentIndex:(NSUInteger)segmentIndex;
- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex;
@end


@interface SegmentedControl : UIView {
  NSObject <SegmentedControlDelegate> *delegate;
  NSMutableArray* buttons;
}

@property (nonatomic, retain) NSMutableArray* buttons;

- (id) initWithSegmentCount:(NSUInteger) segmentCount 
				segmentsize:(CGSize)     segmentsize 
			   dividerImage:(UIImage*)   dividerImage 
						tag:(NSInteger)  objectTag 
				   delegate:(NSObject <SegmentedControlDelegate>*)segmentedControlDelegate;

@end
