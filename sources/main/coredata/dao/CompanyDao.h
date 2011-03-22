
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Dao.h"
#import "CoreDataPersistentManager.h"
#import "CompanyMo.h"


/**
 * DAO for the CompanyMo entity.
 */
@interface CompanyDao : Dao {
}


/**
 * Create an empty company.
 *
 * The company object is NOT saved to the context before returning it to the user. 
 */
-(CompanyMo*) company;


/**
 * Create company with name. 
 *
 * The company object is saved to the context before returning it to the user.
 * Name and url are the only mandatory fields.
 */;
-(CompanyMo*) companyWithName:(NSString*)name andUrl:(NSString*) url;


/** 
 * Find a company by name. 
 * @return CompanyMo or nil.
 */
- (CompanyMo*) findByName:(NSString*)name;
	

@end
