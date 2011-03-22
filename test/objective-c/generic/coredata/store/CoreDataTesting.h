
#import <CoreData/CoreData.h>
#import "CoreDataAbstractManager.h"
#import "JobDao.h"

@interface CoreDataTesting : NSObject {
	CoreDataAbstractManager *_manager;
}
@property (nonatomic, retain) CoreDataAbstractManager *manager;

- (BOOL) test1Entities;
- (BOOL) test2Singleton;
- (BOOL) test3RemoveAll;
- (BOOL) test4Create;
- (BOOL) test5KVC;

@end
