
#import <UIKit/UIKit.h>
#import "GenericPickerView.h"

@interface SalaryPickerView : GenericPickerView {

	NSString *selectedKeyPicker1;
	NSString *selectedKeyPicker2;
	NSString *lastGoodValuePicker1;
	NSString *lastGoodValuePicker2;
	
}

@property (retain,nonatomic) NSString *selectedKeyPicker1;
@property (retain,nonatomic) NSString *selectedKeyPicker2;
@property (retain,nonatomic) NSString *lastGoodValuePicker1;
@property (retain,nonatomic) NSString *lastGoodValuePicker2;

/** Sets the value that the user sees back on the advanced table. */
-(void) updateLastGoodValue;

-(NSString*) maxSalary;
-(NSString*) minSalary;

- (void) reset;

@end
