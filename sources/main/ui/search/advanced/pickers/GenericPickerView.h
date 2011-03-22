
#import <Foundation/Foundation.h>

@interface GenericPickerView : UIPickerView 
	< 
     UIPickerViewDelegate, 
	 UIPickerViewDataSource, 
	 UIActionSheetDelegate 
    >
{

@public
	/** Label to show when no value is selected. */
	NSString *placeholderLabel;
	
	/** Special key to mark an empty row. */
	NSString *NOVALUEKEY;
	
	/** 
	 * Array of labels (extracted from keyValuePairs). s
	 * Not private for access from the subclasses.
     */
	NSArray *sortedKeys;
	
	/** name of the url parameter */
	NSString *lastGoodValue;
	
	/** name of the url parameter */
	NSString *parameterName;
	
	/** 
	 * Key of the option selected by the user. 
	 * This is also used as label in the picker.
	 */
	NSString *selectedKey;
	
	/** Value of the option selected by the user. */
	NSString *selectedValue;
	
	/** 
	 * Dictionary with the key/label pairs for this picker. 
	 * The key will be shown as label in the picker.
	 */
	NSMutableDictionary *keyValuePairs;
	
	/** Title for the picker view */
	NSString *pickerTitle;
	
	int viewTag;
	
}


@property (retain,nonatomic) NSString *NOVALUEKEY;
@property (retain,nonatomic) NSString *selectedKey;
@property (retain,nonatomic) NSString *selectedValue;
@property (retain,nonatomic) NSString *parameterName;
@property (retain,nonatomic) NSString *parameterValue;
@property (retain,nonatomic) NSString *lastGoodValue;
@property (retain,nonatomic) NSString *placeholderLabel;
@property (assign,nonatomic) int viewTag;

-(NSString*) describe;

-(NSString*) searchString;


#pragma mark PickerProtocol

/** Return true if there is a value selected. */
- (BOOL) hasValue;

/** Show the category picker. */
- (void) popupPicker:(id) controller;

/** Set the picker to no value selected. */
- (void) reset;

/** init */
-(id) initWithDictionary:(NSDictionary*) dictionary 
			  noValueKey:(NSString*) noValueKey 
			 placeholder:(NSString*) placeholder
             pickerTitle:(NSString*) pickerTitle
		   parameterName:(NSString*) parameterName;

/** Value of the parameter. */
-(NSString *) parameterValue;

@end




