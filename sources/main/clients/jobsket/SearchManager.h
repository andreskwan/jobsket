
#import <Foundation/Foundation.h>
#import "Query.h"
#import "SearchDao.h"
#import "Query.h"
#import "HtmlToJson.h"
#import "JsonMoBuilder.h"
#import "JsonToMo.h"
#import "HttpDownload.h"


@interface SearchManager : NSObject {
	SearchDao *searchDao;
	CoreDataAbstractManager *manager;
	JsonMoBuilder *jsonMoBuilder;
}

@property (nonatomic,retain) SearchDao *searchDao;
@property (nonatomic, retain) CoreDataAbstractManager *manager;
@property (nonatomic, retain) JsonMoBuilder *jsonMoBuilder;


/** Run the query and return a SearchMo. */
-(SearchMo*) runQuery:(Query*)query;


/** 
 * Run the query and return a SearchMo.
 * If there is no connectivity, the object returned is nil.
 *
 * @return The SearchMo object or nil if the query failed.
 */
-(SearchMo*) runJsonQuery:(Query*)query;


@end
