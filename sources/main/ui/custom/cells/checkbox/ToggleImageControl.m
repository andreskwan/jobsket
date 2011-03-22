
#import "ToggleImageControl.h"

@implementation ToggleImageControl

@synthesize indexPath, normalImage, selectedImage, imageView;


/**
 * Custom accessor to match the image to the selected ivar.
 */
-(void) setSelected:(BOOL) s {
	selected = s;
	self.imageView.image = (s ? selectedImage : normalImage);
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.normalImage = [UIImage imageNamed:@"toggleImageNormal.png"];
        self.selectedImage = [UIImage imageNamed:@"toggleImageSelected.png"];
        self.imageView = [[UIImageView alloc] initWithImage:normalImage];
        //[self setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.imageView];
        [self addTarget:self action:@selector(toggleImage) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}


- (void) toggleImage {
    selected = !selected;
    //[self.imageView.image release];
    self.imageView.image = (self.selected ? self.selectedImage : self.normalImage);

	if (indexPath!=nil) {
		// Using NSNotification to notify data model about state change
		NSDictionary *dict = [NSDictionary dictionaryWithObject:indexPath forKey:@"CellCheckToggled"]; 
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CellCheckToggled" object:self userInfo:dict];
	} else {
		debug(@"indexPath is missing, will skip notification");
	}
	
}


-(void) dealloc {
    [self.imageView release],self.imageView=nil;
    [normalImage release], [selectedImage release];
    [super dealloc];
}



@end
