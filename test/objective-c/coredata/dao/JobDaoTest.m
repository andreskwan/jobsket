
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "JobMo.h"
#import "JobDao.h"
#import "GenericDaoTest.h"
#import "CoreDataPersistentManager.h"


/**
 * Test JobDao methods.
 */
@interface JobDaoTest : GenericDaoTest
@end


@implementation JobDaoTest

	
- (void) setUp {
	if (!dao) {
        [super setUpWithDao:[JobDao class] andMo:[JobMo class]];
		[self setBlock:^(void){
			debug(@"[%@ createWithTitle:@\"Acme Inc.\"]", [dao class]);
			return [dao performSelector:@selector(jobWithName:andUrl:) withObject:@"Acme Inc." withObject:@"http://www.acme.com"];
		}];
	}
	[self removeAll];
}


@end
