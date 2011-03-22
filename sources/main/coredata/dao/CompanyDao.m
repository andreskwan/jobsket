
#import "CompanyDao.h"


@implementation CompanyDao


/**
 * Create an empty company.
 *
 * The company object is NOT saved to the context before returning it to the user. 
 */
-(CompanyMo*) company {
	NSManagedObjectContext *context = [[self manager] context];
	return (CompanyMo*) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CompanyMo class]) 
													  inManagedObjectContext: context];
}


/**
 * Create company with name. 
 *
 * The company object is saved to the context before returning it to the user.
 * Name and url are the only mandatory fields.
 */
-(CompanyMo*) companyWithName:(NSString*)name andUrl:(NSString*) url {
	NSManagedObjectContext *context = [[self manager] context];
	
	CompanyMo *company = (CompanyMo*) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CompanyMo class]) 
													                inManagedObjectContext: context];
	company.name = name;
	company.url = url;
	
	NSError *error;
	if ([context hasChanges] && ![context save:&error]) {
	    warn(@"Error %@", [error localizedDescription]);
	}
	
	return company;
}


- (CompanyMo*) findByName:(NSString*)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSArray *companies = [super objectsOfEntityName:NSStringFromClass([CompanyMo class]) withPredicate:predicate];
    if ((companies==nil) || ([companies count]<1)){
        warn(@"no companies with name %@, returning nil", name);
        return nil;
    } else {
        CompanyMo *company = [companies lastObject];
        //debug(@"found %@", [company shortDescribe]);
        return company;
    }
}


@end
