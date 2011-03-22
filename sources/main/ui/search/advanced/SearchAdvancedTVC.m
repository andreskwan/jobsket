
#import "SearchAdvancedTVC.h"

@implementation SearchAdvancedTVC

@synthesize tableView, searchJobsTVC, clearButton, searchButton;


-(void) popViewController {
	[self.navigationController popViewControllerAnimated:YES]; 
}


/** 
 * Called when clicking Done in the keyboard of the UITextfield of the 1st row of the table. 
 * Set when building the UITextField.
 */
-(IBAction)textFieldDone:(id)sender {
	[sender resignFirstResponder];
}


/** Handle clicking the Clear button. */
-(void) handleClear {

	// nil the textfield and call reset on the pickers
	
	for (int i=0; i<[pickersDictKeys count]; i++) {
		id object = [pickersDict objectForKey:[pickersDictKeys objectAtIndex:i]];
		
		if ([object isKindOfClass:[UITextField class]]){
			((UITextField*) object).text = nil;
		} else if ([object isKindOfClass:[ExperiencePickerView class]]){
			[((ExperiencePickerView*) object) reset];	
		} else if ([object isKindOfClass:[GenericPickerView class]]){
			[((GenericPickerView*) object) reset];
		}	
	}
	
	[self.tableView reloadData];
}


/** Handle clicking the Search Button. */
-(void) handleSearch {
	
	Query *query = [Query new];

	//NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	for(id object in [pickersDict allValues]){
		if ([object isKindOfClass:[SalaryPickerView class]]){
			
			SalaryPickerView *p = (SalaryPickerView*) object;
            if ([p hasValue]){
				query.minSalary = [p minSalary];
				query.maxSalary = [p maxSalary];
			}
			
		} else if ([object isKindOfClass:[UITextField class]]){
			
			UITextField *t = (UITextField*) object;
			if ([t text]) {
				query.keywords = [t text];
			}

		} else if ([object isKindOfClass:[ExperiencePickerView class]]){
			ExperiencePickerView *g = (ExperiencePickerView*) object;
			if ([g hasValue]){
                BOOL hasValue = ![[g parameterValue] isEqualToString:localize(@"picker.novalue.key")];
                if (hasValue) [query setValue:[g parameterValue] forKey:[g parameterName]];
			}
            
		} else if ([object isKindOfClass:[GenericPickerView class]]){
			GenericPickerView *g = (GenericPickerView*) object;
			if ([g hasValue]){
                BOOL hasValue = ![[g parameterValue] isEqualToString:localize(@"picker.novalue.key")];
				if (hasValue) [query setValue:[g parameterValue] forKey:[g parameterName]];
			}
		} 
        
	}
	if (![query isValid]) { warn(@"Query object doesn't appear valid."); }
	
	debug(@"query is %@", [query urlForJsonSearch]);
	debug(@"query as json is %@", [query json]);
	
	SearchManager *searchManager = [[SearchManager new] init];
	SearchMo *searchMo = [searchManager runJsonQuery:query];
    [searchManager release];
    [query release];
    
    if (searchMo==nil){
        // The query only fails when there is no connectivity.
        // Nothing else to do. HttpDownload should have already spawned a warning hud.
        warn(@"Search failed (no connectivity?). Nothing else to do.");
        return;
    }
    
	searchJobsTVC.searchMo = searchMo;
	[self.navigationController pushViewController:searchJobsTVC animated:YES];
	
}


#pragma mark -
#pragma mark View UIActionSheetDelegate


/**
 * Click handler for UIPickerView spawned from table rows.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==1) {
		// user pressed cancel
		[self.tableView reloadData];
		return;
	}
	
	// user pressed ok
	id object = [pickersDict objectForKey:[pickersDictKeys objectAtIndex:[actionSheet tag]]];
	
	if ([object isKindOfClass:[SalaryPickerView class]]){
		SalaryPickerView *g = (SalaryPickerView*) object;
		g.lastGoodValuePicker1 = [g selectedKeyPicker1];
		g.lastGoodValuePicker2 = [g selectedKeyPicker2];
		// salary picker result needs special processing because is not directly the selected value
		[g updateLastGoodValue];

	} else if ([object isKindOfClass:[ExperiencePickerView class]]){
		ExperiencePickerView *g = (ExperiencePickerView*) object;
		g.lastGoodValue = [g selectedKey];
        
	} else if ([object isKindOfClass:[GenericPickerView class]]){
		GenericPickerView *g = (GenericPickerView*) object;
		g.lastGoodValue = [g selectedKey];
	}  	
	
	[self.tableView reloadData];
	
}


#pragma mark -
#pragma mark Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


/**
 * Display the appropiate picker.
 */
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString *key = [pickersDictKeys objectAtIndex:indexPath.row];
	id object = [pickersDict objectForKey:key];
	
	if ([object isKindOfClass:[UITextField class]]){
		// nothing to do
        
	} else if ([object isKindOfClass:[ExperiencePickerView class]]){
		[(ExperiencePickerView*)object popupPicker:self];
        
	} else if ([object isKindOfClass:[GenericPickerView class]]){
		[(GenericPickerView*)object popupPicker:self];
        
	} else {
		debug(@"component undefined in row %d", indexPath.row);
	}

}


# pragma mark -
# pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pickersDict count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
	NSString *key = [pickersDictKeys objectAtIndex:row]; // key from the keys array
	id object = [pickersDict objectForKey:key]; // object with that key from the dictionary
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		if ([object isKindOfClass:[UITextField class]]){
			[cell.contentView addSubview: [pickersDict objectForKey:key] ];
		} 
	}

	// GenericPickerView needs an update of the label to refresh data.
	// UITextField don't need it because the editing process itself updates the data.
	
	if ([object isKindOfClass:[SalaryPickerView class]]){
		SalaryPickerView *picker = (SalaryPickerView*) object;
        // choosing "Any" doesn't count as value
        if ([picker.lastGoodValue isEqualToString:localize(@"picker.novalue.key")]) picker.lastGoodValue=nil; 
        // set values
		cell.textLabel.text = ([picker hasValue]) ? picker.lastGoodValue : [picker placeholderLabel];
		cell.textLabel.textColor = [cell.textLabel.text isEqualToString:[picker placeholderLabel]] 
								   ? UIColorFromRGB(0xB3B3B3) : UIColorFromRGB(0x000000);

	} else if ([object isKindOfClass:[ExperiencePickerView class]]){
		ExperiencePickerView *picker = (ExperiencePickerView*) object;
        // choosing "Any" doesn't count as value
        if ([picker.lastGoodValue isEqualToString:localize(@"picker.novalue.key")]) picker.lastGoodValue=nil;
        // set values
		cell.textLabel.text = [picker hasValue] ? picker.lastGoodValue : [picker placeholderLabel];
		cell.textLabel.textColor = [cell.textLabel.text isEqualToString:[picker placeholderLabel]] 
        ? UIColorFromRGB(0xB3B3B3) : UIColorFromRGB(0x000000);
        
	} else if ([object isKindOfClass:[GenericPickerView class]]){
		GenericPickerView *picker = (GenericPickerView*) object;
        // choosing "Any" doesn't count as value
        if ([picker.lastGoodValue isEqualToString:localize(@"picker.novalue.key")]) picker.lastGoodValue=nil;
        // set values
		cell.textLabel.text = [picker hasValue] ? picker.lastGoodValue : [picker placeholderLabel];
		cell.textLabel.textColor = [cell.textLabel.text isEqualToString:[picker placeholderLabel]] 
                                   ? UIColorFromRGB(0xB3B3B3) : UIColorFromRGB(0x000000);
	}
	
    return cell;
}


# pragma mark -
# pragma mark custom UIViewController

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



- (void)viewDidLoad {
	debug(@"\n");
	debug(@"ADVANCEDTVC ////////////////////////////////////////////////////////////////////\n\n");

    // 0x33963E red cancel, 0x9F2622 green call, 0xD3D3D6 gray, 0x394450 my buttons
    self.clearButton.tint=[Themes getColor:HEXCOLOR_ADVANCEDSEARCH_BUTTON_FG];
    self.searchButton.tint=[Themes getColor:HEXCOLOR_ADVANCEDSEARCH_BUTTON_FG];
    [self.clearButton setTitleColor:[Themes getColor:HEXCOLOR_ADVANCEDSEARCH_BUTTON_BG] forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[Themes getColor:HEXCOLOR_ADVANCEDSEARCH_BUTTON_BG] forState:UIControlStateNormal];
    
    // next two lines hide the table for some reason, so I call handleClear from viewLoad
    self.clearButton.titleLabel.font = [Themes getFont:FONT_ADVANCEDSEARCH_BUTTON];
    self.searchButton.titleLabel.font = [Themes getFont:FONT_ADVANCEDSEARCH_BUTTON];
    
    [self.clearButton setTitle:localize(@"advancedsearch.button.clear") forState:UIControlStateNormal];
    [self.searchButton setTitle:localize(@"advancedsearch.button.search") forState:UIControlStateNormal];
    
    
    PickersData *pickersData = [PickersData new];
    
	GenericPickerView *pickerCategory = [[[GenericPickerView alloc] 
									     initWithDictionary:[pickersData categoryDictionary]
						                 noValueKey:localize(@"picker.novalue.key")
						                 placeholder:localize(@"picker.placeholder.category")
						                 pickerTitle:localize(@"picker.pickerTitle.category")
										 parameterName:@"category"] autorelease];
	
	GenericPickerView *pickerLocation = [[[GenericPickerView alloc] 
										 initWithDictionary:[pickersData locationDictionary]
										 noValueKey:localize(@"picker.novalue.key")
										 placeholder:localize(@"picker.placeholder.location")
										 pickerTitle:localize(@"picker.pickerTitle.location")
										  parameterName:@"location"] autorelease];
	
	ExperiencePickerView *pickerExperience = [[[ExperiencePickerView alloc] 
										   initWithDictionary:[pickersData experienceDictionary]
										   noValueKey:localize(@"picker.novalue.key")
										   placeholder:localize(@"picker.placeholder.experience")
										   pickerTitle:localize(@"picker.pickerTitle.experience")
                                           parameterName:@"experience"] autorelease];
	
	GenericPickerView *pickerSalary = [[[SalaryPickerView alloc] 
										initWithDictionary:[pickersData salaryDictionary]
										noValueKey:localize(@"picker.novalue.key")
										placeholder:localize(@"picker.placeholder.salary")
										pickerTitle:localize(@"picker.pickerTitle.salary")
										parameterName:@"## not used ##"] autorelease];
	[pickersData release];
    
	// Create a textfield
	// (cell.frame.origin.x+8, cell.frame.origin.y+11) = (8.0, 11.0)
	UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(8.0, 11.0, 280, 31)] retain];
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.clearsOnBeginEditing = NO;
	[textField setDelegate:self];
	textField.returnKeyType = UIReturnKeyDone;
	textField.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	textField.placeholder = localize(@"picker.placeholder.keywords");
	textField.clearButtonMode = UITextFieldViewModeNever;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	[textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[textField setEnabled:YES];
	
	pickersDict = [NSMutableDictionary dictionaryWithCapacity:5];
	[pickersDict setObject:textField        forKey:@"Keywords"];
	[pickersDict setObject:pickerCategory   forKey:@"Category"];
	[pickersDict setObject:pickerLocation   forKey:@"Location"];
	[pickersDict setObject:pickerExperience forKey:@"Experience"];
	[pickersDict setObject:pickerSalary     forKey:@"Salary"];
	[pickersDict retain];

	pickersDictKeys = [[NSArray arrayWithObjects:@"Keywords", @"Category", @"Experience", @"Location", @"Salary", nil] retain];
		
	// tag
	for(NSUInteger i=0; i<[pickersDictKeys count]; i++) {
		id object = [pickersDict objectForKey:[pickersDictKeys objectAtIndex:i]];
        
	    if ([object isKindOfClass:[ExperiencePickerView class]]){
			[(ExperiencePickerView*) object setViewTag:i];
            
		} else if ([object isKindOfClass:[GenericPickerView class]]){
			[(GenericPickerView*) object setViewTag:i];
		}
	}
	
	// search button
	UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];  
    UIImage *searchImage = [Themes getCachedImage:PNG_TOP_BAR_SEARCH];
	[search setBackgroundImage:searchImage forState:UIControlStateNormal];  
    [search addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	search.frame = CGRectMake(0, 0, searchImage.size.width, searchImage.size.height);
    UIBarButtonItem *searchbi = [[[UIBarButtonItem alloc] initWithCustomView:search] autorelease];  
	self.navigationItem.leftBarButtonItem = searchbi;
	
	// set table background
	UIImage *tableBackground = [[Themes getCachedImage:PNG_TABLE_BG] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	UIImageView *bgView = [[[UIImageView alloc] initWithImage:tableBackground] autorelease];
	self.tableView.backgroundView = bgView;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:tableBackground];
    
    // If we set the font in the button the table doesn't show. This reloads the table.
    [self handleClear];
    
    [super viewDidLoad];
}
	
	

@end
