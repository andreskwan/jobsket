
#import <CoreLocation/CoreLocation.h>
#import "JsonParser.h"
#import "JobDao.h"
#import "CompanyDao.h"
#import "SearchDao.h"
#import "NSDate+InternetDateTime.h"
#import "Query.h"
#import "HttpDownload.h"
#import "Geocoding.h"

#import "RegexKitLite.h"
#import "GTMNSString+HTML.h"
#import "NSString+Levenshtein.h"


@interface JsonMoBuilder : NSObject {
	JobDao *jobDao;
	CompanyDao *companyDao;
    SearchDao *searchDao;
	Geocoding *geocoding;
}

@property(nonatomic,retain) Geocoding *geocoding;
@property(nonatomic,retain) JobDao *jobDao;
@property(nonatomic,retain) CompanyDao *companyDao;
@property(nonatomic,retain) SearchDao *searchDao;


-(JobMo*) parseJob:(NSString*)json;
-(NSSet*) parseJobs:(NSString*)json;
-(JobMo*) parseJobFromArray:(NSArray*)array;

-(SearchMo*) parseSearch:(NSString*)json fromQuery:(Query*)query;

-(NSSet*) parseCompanies:(NSString*)json;
-(CompanyMo*) parseCompany:(NSDictionary*)companyDic;

-(CompanyMo*) lookUpCompany:(NSString*)companyName;


@end


/*
parseJob: recibe un array en el que cada elemento es un diccionario con una única clave (category, city, ...).
 
{ "job":[
	{ "category"    : "Logística y Almacén" },
	{ "city"        : "A Coruña" },
	{ "companyName" : "EGA Consultores" },
	{ "content"     : "<p class='jobsectioncontent'> Nuestro cliente, blah blah blah </p>" }
	{ "date"        : "2010-12-22T17:20:40Z" },
	{ "experience"  : "2-3 years in experience" },
	{ "maxSalary"   : null },
	{ "minSalary"   : null },
	{ "place"       : "Coruña (A)" },
	{ "reference"   : null },
	{ "status"      : "Open" },
	{ "title"       : "COORDINADOR/A OPERACIONES PORTUARIAS" },
	{ "url"         : "http://ats.jobsket.com/jobOffers/showjoboffer/coordinador_a_operaciones_portuarias" },
	{ "visits"      : 354 },
]}
 
*/