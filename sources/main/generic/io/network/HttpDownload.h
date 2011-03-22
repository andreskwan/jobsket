
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "UIApplication+Extension.h"
#import "Reachability.h"

@interface HttpDownload : NSObject {
	NSDictionary *encodings;
	UIActivityIndicatorView *spinner;
	UIActivityIndicatorView *activityView;
    Reachability *reach;
}

@property (nonatomic,retain) Reachability *reachability;
@property (nonatomic,retain) UIActivityIndicatorView *activityView;
@property (nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSDictionary *encodings;


- (NSData *) cleanPageAsDataFromUrl:(NSString *)sUrl;
- (NSString *) cleanPageAsStringFromUrl:(NSString *) sUrl;

- (NSData *) pageAsDataFromUrl:(NSString *)sUrl;
- (NSString *) pageAsStringFromUrl:(NSString *) sUrl;

/** URL encode the original string and return a URL */
- (NSURL*) encodedUrl:(NSString*) url;


// -(void) spinTheSpinner;
// -(void) doneSpinning;


@end
