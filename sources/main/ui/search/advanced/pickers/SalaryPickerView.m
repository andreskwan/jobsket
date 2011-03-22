
#import "SalaryPickerView.h"


@implementation SalaryPickerView

@synthesize selectedKeyPicker1, selectedKeyPicker2, lastGoodValuePicker1, lastGoodValuePicker2;


/** 
 * Sort numerically but put the given key on top. 
 * This goes K-BOOM if a key other than keyOnTop is not numeric.
 */
-(NSArray*) cheatedSort:(NSArray*)unsortedKeys keyOnTop:(NSString*)keyOnTop {
	return [unsortedKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
		return ([obj1 isEqualToString:keyOnTop]) 
		       ? NSOrderedAscending 
		       : [[NSNumber numberWithInt:[obj1 intValue]] compare: [NSNumber numberWithInt:[obj2 intValue]] ];
	}];
}


/** Reset the picker to the no value position. */
- (void) reset {
	lastGoodValuePicker1 = nil;
	lastGoodValuePicker2 = nil;
    selectedKey = NOVALUEKEY;
	selectedValue = [keyValuePairs objectForKey:selectedKey];
}


/** Return true if there is a value selected (other than the NOVALUE marker). */
- (BOOL) hasValue {	
	BOOL minSalarySet = lastGoodValuePicker1!=nil && ![lastGoodValuePicker1 isEqualToString:NOVALUEKEY];
	BOOL maxSalarySet = lastGoodValuePicker2!=nil && ![lastGoodValuePicker2 isEqualToString:NOVALUEKEY];
	return minSalarySet || maxSalarySet;
} 


-(NSString*) minSalary {
	BOOL minSalarySet = lastGoodValuePicker1!=nil && ![lastGoodValuePicker1 isEqualToString:NOVALUEKEY];
	if (minSalarySet) return lastGoodValuePicker1;
	else return @"";
}


-(NSString*) maxSalary {
	BOOL maxSalarySet = lastGoodValuePicker2!=nil && ![lastGoodValuePicker2 isEqualToString:NOVALUEKEY];
	if (maxSalarySet) return lastGoodValuePicker2;
	else return @"";
}


-(NSString*) searchString {

	BOOL minSalarySet = lastGoodValuePicker1!=nil && ![lastGoodValuePicker1 isEqualToString:NOVALUEKEY];
	BOOL maxSalarySet = lastGoodValuePicker2!=nil && ![lastGoodValuePicker2 isEqualToString:NOVALUEKEY];
		
	if (!(minSalarySet || maxSalarySet)) return @"";
	
	NSString *result;
	if (!minSalarySet && !maxSalarySet){ // nothing set
		result = @"";
		
	} else if (minSalarySet && maxSalarySet){ // both set
		result = [NSString stringWithFormat:@"minSalary=%@&maxSalary=%@", lastGoodValuePicker1, lastGoodValuePicker2];
		
	} else if (!minSalarySet && maxSalarySet){ // only max set
		result = [NSString stringWithFormat:@"maxSalary=%@", lastGoodValuePicker2];
		
	} else if (minSalarySet && !maxSalarySet){ // only min set
		result = [NSString stringWithFormat:@"minSalary=%@", lastGoodValuePicker1];
		
	}
	
	return result;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

// number of wheels
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}



/** Update label and value in response to the user selecting a row. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	const int noLimitRow = 0;
	int rowC0 = [self selectedRowInComponent:0];
	int rowC1 = [self selectedRowInComponent:1];	
	
	// IF (min salary > max salary) AND (one of the two is NOT set on NoLimit) 
	BOOL invalid = (rowC0>rowC1) && !(rowC0==noLimitRow || rowC1==noLimitRow);
	
	if (invalid){
		// set the other component (the one we didn't change the last time) to the same row
		[self selectRow:[self selectedRowInComponent:component] inComponent:!component animated:YES];
	}
	
	/* we need the row position on both components to update the labels,
	 but if the position was invalid, the wheels may be still spinning (animated:YES)
	 so we need to update manually instead using selectedRowInComponent:
	 */
	if (invalid){		
		rowC0 = component==0 ? rowC0 : rowC1;
		rowC1 = component==1 ? rowC1 : rowC0;
	} else {
		rowC0 = [self selectedRowInComponent:0];
		rowC1 = [self selectedRowInComponent:1];
	}
	
	// if position was invalid both components changed, so I always update both (faster than adding ifs)
	selectedKeyPicker1 = [sortedKeys objectAtIndex:rowC0];
	selectedKeyPicker2 = [sortedKeys objectAtIndex:rowC1];
	
	debug(@"set to %@, %@", selectedKeyPicker1, selectedKeyPicker2);
}


/** Sets the value that the user sees back on the advanced table. */
-(void) updateLastGoodValue {
	BOOL minSalarySet = lastGoodValuePicker1!=nil && ![lastGoodValuePicker1 isEqualToString:NOVALUEKEY];
	BOOL maxSalarySet = lastGoodValuePicker2!=nil && ![lastGoodValuePicker2 isEqualToString:NOVALUEKEY];
	
	NSString *result;
	if (!minSalarySet && !maxSalarySet){ // nothing set
		result = [NSString stringWithFormat:@"%@", localize(@"salary")];
		
	} else if (minSalarySet && maxSalarySet){ // nothing unset
		result = [NSString stringWithFormat:@"%@ %@ to %@€", 
					   localize(@"salary"),lastGoodValuePicker1, lastGoodValuePicker2];
		
	} else if (!minSalarySet && maxSalarySet){ // only max set
		result = [NSString stringWithFormat:@"%@ %@€ %@ ",
					   localize(@"salary"), lastGoodValuePicker2, localize(@"maximum")];
		
	} else if (minSalarySet && !maxSalarySet){ // only min set
		result = [NSString stringWithFormat:@"%@ %@€ %@ ",
					   localize(@"salary"), lastGoodValuePicker1, localize(@"minimum")];
	}
	debug(@"last good value updated to %@", result);
	[self setLastGoodValue:result];
}


@end


