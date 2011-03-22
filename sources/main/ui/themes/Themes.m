
#import "Themes.h"

@implementation Themes

static NSMutableDictionary *images;


/** Initialize an object for each of the enums in ImagesEnum.h. */
+(void) initialize { 
	if (self == [Themes class]) {
        images = [[NSMutableDictionary alloc] init];

        [images setObject:@"PNG_BTN_ADVANCED_SEL" forImages:PNG_BTN_ADVANCED_SEL];
        [images setObject:@"PNG_BTN_ADVANCED_UNSEL" forImages:PNG_BTN_ADVANCED_UNSEL];
        [images setObject:@"PNG_SEARCH_CANCEL_SEL" forImages:PNG_SEARCH_CANCEL_SEL];
        [images setObject:@"PNG_SEARCH_CANCEL_UNSEL" forImages:PNG_SEARCH_CANCEL_UNSEL];        
        [images setObject:@"TOP_BAR_BG" forImages:PNG_TOP_BAR_BG];
        [images setObject:@"TOP_BAR_TITLE" forImages:PNG_TOP_BAR_TITLE];
        [images setObject:@"SBAR_BG" forImages:PNG_SBAR_BG];
        [images setObject:@"TABLE_BG" forImages:PNG_TABLE_BG];
        [images setObject:@"SECTION_BG" forImages:PNG_SECTION_BG];
        [images setObject:@"CELL_BG" forImages:PNG_CELL_BG];
        [images setObject:@"TOP_BAR_BACK" forImages:PNG_TOP_BAR_BACK];
		[images setObject:@"TOP_BAR_FAV_BTN" forImages:PNG_TOP_BAR_FAV_BTN];
		[images setObject:@"TOP_BAR_FAV_BTN_SHALLOW" forImages:PNG_TOP_BAR_FAV_BTN_SHALLOW];
		[images setObject:@"TOP_BAR_FAV_BTN_STAR" forImages:PNG_TOP_BAR_FAV_BTN_STAR];
		[images setObject:@"PNG_TOP_BAR_SEARCH" forImages:PNG_TOP_BAR_SEARCH];
        [images setObject:@"PNG_TOP_BAR_FAVORITES" forImages:PNG_TOP_BAR_FAVORITES];
        [images setObject:@"PNG_TOP_BAR_JOBS" forImages:PNG_TOP_BAR_JOBS];
		[images setObject:@"TABLE_JOBDETAIL_BG2" forImages:PNG_TABLE_JOBDETAIL_BG];
        [images setObject:@"PNG_TOP_BAR_DETAIL" forImages:PNG_TOP_BAR_DETAIL];
		[images setObject:@"TABLE_WOOD_BG" forImages:PNG_TABLE_WOOD_BG];
		[images setObject:@"PNG_TABLE_SEPARATOR" forImages:PNG_TABLE_SEPARATOR];
		[images setObject:@"btn-map-up"   forImages:PNG_BTN_MAP_UP];
		[images setObject:@"btn-map-down" forImages:PNG_BTN_MAP_DOWN];
        [images setObject:@"ico-warning.png" forImages:PNG_ICO_WARNING];
        [images setObject:@"ico-radar.png"   forImages:PNG_ICO_RADAR];
        
		[images setObject:@"0x526691" forImages:HEXCOLOR_JOBDETAIL_CELL_TITLE];
        [images setObject:@"0x677886" forImages:HEXCOLOR_SBAR_BUTTON];
        [images setObject:@"0x647481" forImages:HEXCOLOR_SEGMENTED_CONTROL];
		[images setObject:@"0xFFFFFF" forImages:HEXCOLOR_ADVANCEDSEARCH_BUTTON_FG];
		[images setObject:@"0x000000" forImages:HEXCOLOR_ADVANCEDSEARCH_BUTTON_BG];
        
        [images setObject:[UIFont systemFontOfSize:14] forImages:FONT_SEARCH_CELLDETAIL];
		[images setObject:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:18] forImages:FONT_JOBDETAIL_TITLE];
		[images setObject:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:15] forImages:FONT_JOBDETAIL_CELLTITLE];
        [images setObject:[UIFont fontWithName:@"Helvetica" size:11]               forImages:FONT_JOBDETAIL_PUBLISHED];
        [images setObject:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]    forImages:FONT_SEARCH_CELLHEADER];
		[images setObject:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]    forImages:FONT_ADVANCEDSEARCH_BUTTON];
		[images setObject:[UIFont fontWithName:@"VAGRoundedStd-Light" size:14]     forImages:FONT_JOBDETAIL_CELLCONTENT];
        
	}
}


/**
 * Return an UIColor.
 * @param color Dictionary key to a string containing the hex number of a color.
 */
+ (UIColor*) getColor:(enum Images)color {
	NSScanner* scanner = [NSScanner scannerWithString: [images objectForImages:color]];	
	unsigned int iValue;
	[scanner scanHexInt: &iValue];
	return UIColorFromRGB(iValue);
}


+ (UIFont*) getFont:(enum Images)fontKey {
	return (UIFont*)[images objectForImages:fontKey];
}


/*
+ (UIImage*) getImage:(enum Images)path {
	return nil;
}
*/


/**
 * Return an UIImage with the given path.
 * First it looks for image with name path + language_code, if not found it tries just "path".
 *
 * Since images only load once in viewDidLoad, this doesn't waste too much time.
 * 
 * @param path Dictionary key to a string containing a filename.
 */
+ (UIImage*) getCachedImage:(enum Images)path {
    
    static NSSet *cacheFail = nil;
    if (cacheFail==nil){ cacheFail = [NSSet set]; }
    
	NSString *imagePath = (NSString*)[images objectForImages:path];
    UIImage *image = nil;
    
    // try name with _language suffix
    NSString *key = [imagePath stringByAppendingFormat:@"_%@",[Themes preferredLanguage]];
    if ([[cacheFail valueForKey:key] count]==0){
        image = [UIImage imageNamed:key];
        if (image==nil){ 
            [cacheFail setValue:@"" forKey:key]; 
        }
    }
    
    // try normal name
    if (image==nil){
        image = [UIImage imageNamed:imagePath];
    }
    
    if (image==nil) { warn(@"Missing image for %@", imagePath); }
	return image; 
}


+(NSString*) preferredLanguage {
    static NSString *preferredLanguage = nil;
    if (preferredLanguage==nil){
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defs objectForKey:@"AppleLanguages"];
        preferredLanguage = [languages objectAtIndex:0];
    }
    return preferredLanguage;
}



@end
