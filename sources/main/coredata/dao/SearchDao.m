
#import "SearchDao.h"


@implementation SearchDao


/**
 * Create a search object. This object is not saved.
 */
-(SearchMo*) search {
	NSManagedObjectContext *context = [[self manager] context];
	SearchMo *searchMo =  (SearchMo*) [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([SearchMo class]) 
						                                            inManagedObjectContext: context];
	return searchMo;
}


/**
 * Create a new search object using an url.
 * This object is automatically saved.
 *
 * url is the only mandatory field.
 */
-(SearchMo*) searchWithUrl:(NSString*)url {
	NSManagedObjectContext *context = [[self manager] context];
	SearchMo *search = (SearchMo*) [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([SearchMo class]) 
																 inManagedObjectContext: context];
	search.url = url;
	
	NSError *error;
	if ([context hasChanges] && ![context save:&error]) {
	    warn(@"Error saving SearchMo %@, %@, %@", error, [error userInfo],[error localizedDescription]);
	}
	
	return search;
}


-(NSArray*) searchNotFavoritesOlderThan:(NSDate*)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@ && favorite = %@",date, [NSNumber numberWithBool:FALSE]];
    NSArray *searches = [self objectsOfEntityName:NSStringFromClass([SearchMo class]) 
                                    withPredicate:predicate];
    return searches;
}


/**
 * Search for a SearchMo object with the given url.
 */
- (SearchMo *) findByUrl:(NSString *) url {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url = %@",url];
	NSArray *searches = [super objectsOfEntityName:NSStringFromClass([SearchMo class]) withPredicate:predicate];
    debug(@"    %d hits for SearchMo with url = %@", [searches count], url);
    return [searches lastObject];
}


/**
 * Search for SearchMo objects with the given favorite flag.
 */
- (NSArray*) findByFavorite:(NSNumber*) favorite {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite = %@", favorite ];
	NSArray *searches = [super objectsOfEntityName:NSStringFromClass([SearchMo class]) withPredicate:predicate];
    debug(@"    %d hits for SearchMo with favorite = %@", [searches count], favorite);
    return searches;
}


@end
