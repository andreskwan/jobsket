
#import <CoreData/CoreData.h>
#import "Dao.h"
#import "SearchMo.h"
#import "CoreDataPersistentManager.h"


/**
 * DAO for the SearchMo entity.
 */
@interface SearchDao : Dao {
}


/**
 * Create a new search object using an url.
 * url is the only mandatory field.
 */
-(SearchMo*) searchWithUrl:(NSString*)url;


/**
 * Return SearchMo objects with the given url, or nil if none was found.
 */
- (SearchMo *) findByUrl:(NSString *) url;


/**
 * Search filtering by favorite.
 */
- (NSArray*) findByFavorite:(NSNumber*) favorite;


/**
 * Create a search object. This object is not saved.
 */
-(SearchMo*) search;


/**
 * Return SearchMo objects with 'date' older than the given date.
 */
-(NSArray*) searchNotFavoritesOlderThan:(NSDate*)date;


@end
