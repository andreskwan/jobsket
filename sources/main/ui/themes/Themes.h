
#import <UIKit/UIKit.h>
#import "NSMutableDictionary+objectForImages.h"
#import "NSValue+valueWithImages.h"

/**
 * For each font, image, or color in our application we need to add an 
 * enum in ImagesEnum then set a value in the init method of this class.
 *
 * Sample use: 
 *     UIFont *font = [Themes getFont:FONT_SEARCH_CELLHEADER];
 *     UIImage *image = [Themes getCachedImage:PNG_TOP_BAR_FAV_BTN];
 *     UIColor *color = [Themes getColor:HEXCOLOR_SEGMENTED_CONTROL];
 */
@interface Themes : NSObject {
}

+ (UIColor*) getColor:(enum Images) color;
+ (UIImage*) getCachedImage:(enum Images) path;
+ (UIFont*) getFont:(enum Images) fontKey;
+ (NSString*) preferredLanguage;

//+ (UIImage*) getImage:(enum Images) path;

@end
