
#import <Foundation/Foundation.h>
#import "CoreDataPersistentManager.h"
#import "Dao.h"
#import "SearchDao.h"
#import "CompanyDao.h"
#import "JobDao.h"
#import "JsonParser.h"


/**
 * Creates SearchMo objects from JSON data.
 */
@interface JsonToMo : NSObject {
    JobDao *jobDao;
    SearchDao *searchDao;
	CompanyDao *companyDao;
	CoreDataAbstractManager *manager;
}

@property (nonatomic, retain) JobDao *jobDao;
@property (nonatomic, retain) SearchDao *searchDao;
@property (nonatomic, retain) CompanyDao *companyDao;
@property (nonatomic, retain) CoreDataAbstractManager *manager;


/**
 * Call searchFromJson and capture exceptions. 
 * Return nil if anything goes wrong.
 */
-(SearchMo*) safeSearchFromJson:(NSString*) jsonString;


/** 
 * Build a saved SearchMo object from JSON data. 
 */
-(SearchMo*) searchFromJson:(NSString*) jsonString;


/**
 * Fill the job with detail info from the job detail page.
 */
-(JobMo*) fillin:(JobMo*)jobMo with:(NSString*)jsonString;


@end
