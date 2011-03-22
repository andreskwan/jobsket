
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Extension)

+(UIImage*) imageFromView:(UIView*) view;

-(void)saveAsPngWithName:(NSString*)imageName;

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;


@end
