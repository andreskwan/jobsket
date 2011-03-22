
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CoreDataMemoryManager.h"
#import "CompanyDao.h"
#import "CompanyMo.h"
#import "GenericDaoTest.h"


@interface CompanyDaoTest : GenericDaoTest
@end


@implementation CompanyDaoTest


- (void) setUp {
	if (!dao){
		[super setUpWithDao:[CompanyDao class] andMo:[CompanyMo class]];
		[self setBlock:^(void){
			return [dao performSelector:@selector(companyWithName:andUrl:) withObject:@"Acme Inc." withObject:@"http://www.acme.com"];
		}];
	}
	[self removeAll];
}


@end
