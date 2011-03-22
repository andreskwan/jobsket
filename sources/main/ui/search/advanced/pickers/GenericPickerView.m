
#import "GenericPickerView.h"


@implementation GenericPickerView

@synthesize selectedKey, selectedValue, viewTag, NOVALUEKEY, lastGoodValue, parameterName, placeholderLabel, parameterValue;


-(NSString*) parameterValue {
	return [self hasValue] ? [keyValuePairs objectForKey:lastGoodValue] : @"";
}


-(NSString*) searchString {
	if ([self hasValue]){
		return [NSString stringWithFormat:@"%@=%@", parameterName, [keyValuePairs objectForKey:lastGoodValue]];
	} else {
		return [NSString stringWithFormat:@"%@=", parameterName];
	}
}


/** Sort alphabetically but put the given key on top. */
-(NSArray*) cheatedSort:(NSArray*)unsortedKeys keyOnTop:(NSString*)keyOnTop {
	return [unsortedKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
		NSComparisonResult result = [obj1 isEqualToString:keyOnTop] ? NSOrderedAscending
		: [obj2 isEqualToString:keyOnTop] ? NSOrderedDescending
		: [obj1 caseInsensitiveCompare:obj2];
		return result;
	}];
}


#pragma mark -
#pragma mark PickerProtocol


/** Return true if there is a value selected (other than the NOVALUE marker). */
- (BOOL) hasValue {
	return lastGoodValue!=nil;
} 


/** 
 * Show the category picker. 
 * @param controller Delegate for the picker.
 */
- (void)popupPicker:(id) controller {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:localize(pickerTitle)
								  delegate:controller
								  cancelButtonTitle:localize(@"cancel")
								  destructiveButtonTitle:nil
								  otherButtonTitles:localize(@"ok"), nil];
	
	// tag so we know which sheet is which
	actionSheet.tag = viewTag;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.showsSelectionIndicator = YES;
	
	/* Little problem here:
     - You can use showFromToolbar or showFromTabBar, it works but you get a GCC warning.
     - You can use showInView, but the UIPickerView will be clipped by the tabBar. */
	
	// add sheet
	[actionSheet showFromTabBar: (UITabBar*)[controller tableView]];
	
    // sheet frame
    CGRect menuRect = actionSheet.frame;
    menuRect.origin.y -= 214;
    menuRect.size.height = 390;
    actionSheet.frame = menuRect;
	
    // picker frame
    CGRect pickerRect = self.frame;
    pickerRect.origin.y = 174;
    self.frame = pickerRect;
	
	// add picker
	[actionSheet addSubview:self];
    
    // release
    [actionSheet release];
}


/** Reset the picker to the no value position. */
- (void) reset {
	lastGoodValue = nil;
    selectedKey = NOVALUEKEY;
	selectedValue = [keyValuePairs objectForKey:selectedKey];
    [self selectRow:0 inComponent:0 animated:NO];
}


#pragma mark -
#pragma mark UIPickerViewDelegate


/** Return the label for the given row */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [sortedKeys objectAtIndex:row];
}


/** Update label and value in response to the user selecting a row. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    debug(@"objectatrow=%@, row=%d, selectedValue: %@, picker.novalue.key: %@", [sortedKeys objectAtIndex:row], row, selectedValue, localize(@"picker.novalue.key"));
    
    if (![[sortedKeys objectAtIndex:row] isEqualToString:localize(@"picker.novalue.key")]){
        // update label and key
        selectedKey = [sortedKeys objectAtIndex:row];
        selectedValue = [keyValuePairs objectForKey:selectedKey];   
    } else {
        [self reset];
        debug(@"Resetting because you choose Any");
    }
}


#pragma mark -
#pragma mark UIPickerViewDataSource


/** Return the number of rows in the UIPickerView. */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [sortedKeys count];
}


/** Return the number of wheels in the UIPickerView. */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}


#pragma mark -
#pragma mark NSObject


-(NSString *) describe {
	return [NSString stringWithFormat:
			@"GenericPickerView:\n pickerTitle=%@, selectedKey=%@, selectedValue=%@, noValueKey=%@, placeholder=%@", 
			pickerTitle, selectedKey, selectedValue, NOVALUEKEY, placeholderLabel];
}


#pragma mark -
#pragma mark object lifecycle


/**
 * @param dictionary  Dictionary with the key/value pairs that feed this picker.
 * @param noValueKey  Special key indicating that no key is selected. It should be in the dictionary.
 * @param placeholder 
 * @param title
 * @param parameter
 */
-(id) initWithDictionary:(NSDictionary*) dictionary 
			  noValueKey:(NSString*) noValueKey 
			 placeholder:(NSString*) placeholder
             pickerTitle:(NSString*) title 
		   parameterName:(NSString*) parameter {

	self = [super init];
	if (!self) return nil;
	
    /* for (id key in dictionary){
        debug(@"%@ = %@", key, [dictionary objectForKey:key]);
    } */
    
	if ([dictionary objectForKey:noValueKey]==nil) {
		warn(@"MISSING NO-VALUE-KEY %@ ON THE DICTIONARY", noValueKey);
    }
	
	parameterName = parameter;
	
	// data that feeds this picker
	keyValuePairs = [dictionary retain];
	
	// marker key indicating nothing is selected
	NOVALUEKEY = [noValueKey retain];
	
	placeholderLabel = placeholder;
	
	pickerTitle = title;
	
	sortedKeys = [[self cheatedSort:[keyValuePairs allKeys] keyOnTop:NOVALUEKEY] retain];
	
	// set picker to no value selected
	[self reset];
		
	self.delegate = self;
	self.dataSource = self;
	
	return self;
}


-(void) dealloc {
	[keyValuePairs retain];
	[super dealloc];
}


@end
