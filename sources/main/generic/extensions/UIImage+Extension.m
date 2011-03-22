
#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+(UIImage*) imageFromView:(UIView*) view {
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}


-(void) saveAsPngWithName:(NSString*)imageName {
	
    // convert image to PNG format
    NSData *imageData = UIImagePNGRepresentation(self);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// save to the documents dir of the application
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
}


- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
	CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropped;	
}


@end
