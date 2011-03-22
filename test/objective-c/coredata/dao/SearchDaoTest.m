
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>

#import "JobMo.h"
#import "JobDao.h"
#import "SearchMo.h"
#import "SearchDao.h"
#import "CompanyDao.h"
#import "GenericDaoTest.h"
#import "CoreDataMemoryManager.h"


/**
 * Test SearchDao methods.
 */
@interface SearchDaoTest : GenericDaoTest {
@private
	JobDao *jobDao;
	CompanyDao *companyDao;
}
@property (nonatomic, retain) JobDao *jobDao;
@property (nonatomic, retain) CompanyDao *companyDao;

- (void) removeAll;
- (void) test21CreateNoChilds;       // single search
- (void) test22SearchWithPredicate;  // look for a search using a predicate
- (void) test23SearchByFavorite;     // look for a search using a favorite flag in the predicate

- (void) test24CreateWithChilds;     // search and 2 jobs
- (void) test25CascadeChildRemoval;  // delete children automatically when parent is deleted
- (void) test26ChildRemoval;         // delete a child

- (void) test27CreateWithChildsAndCompany;     // search and 2 jobs from 1 company

@end



@implementation SearchDaoTest

@synthesize jobDao, companyDao;


- (void) setUp {
	if (!dao){ 
		[self setUpWithDao:[SearchDao class] andMo:[SearchMo class]];
		[self setBlock:^(void){
			return [dao performSelector:@selector(searchWithUrl:) withObject:@"http://www.jobsket.es/search?keywords=java" ];
		}];
		
		jobDao = [[JobDao alloc] initWithManager:manager];
		companyDao = [[CompanyDao alloc] initWithManager:manager];
	}
	[self removeAll];
}



/** 
 * Remove all instances of JobMo and SearchMo. 
 */
-(void) removeAll {
	// remove SearchMo
	[super removeAll];

	// remove JobMo
    [jobDao removeAllByClassName:NSStringFromClass([JobMo class])]; 
	int instances = [[jobDao objectsOfEntityName:NSStringFromClass([JobMo class])] count];
	STAssertTrue(instances==0, @"There should be no JobMo instances.");
}


/** 
 * Test creating a single SearchMo without children. 
 */
- (void) test21CreateNoChilds {
	SearchMo *searchMo1 = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	searchMo1.favorite = [NSNumber numberWithBool:NO];
	searchMo1.keywords = @"java";
	searchMo1.jobs = nil;
	
	NSArray *results = [dao objectsOfEntityName:NSStringFromClass([SearchMo class])];
	
	debug(@"%d results",[results count]);
	STAssertTrue([results count]==1, @"There should be 1 SearchMo instance.");
	
	SearchMo *searchMo = [results lastObject];
	STAssertTrue([searchMo.keywords isEqualToString:@"java"], @"Keywords field should be java, but is %@",[searchMo keywords]);
	
}


/** 
 * Test searching with a predicate 
 */
- (void) test22SearchWithPredicate {

	SearchMo *searchMo1 = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	searchMo1.keywords = @"java";
	searchMo1.favorite = [NSNumber numberWithBool:NO];
	searchMo1.jobs = nil;

	SearchMo *searchMo2 = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=ruby"];
	searchMo2.favorite = [NSNumber numberWithBool:NO];
	searchMo2.jobs = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keywords = %@",@"java"];
	int i = [[dao objectsOfEntityName:NSStringFromClass([SearchMo class]) withPredicate:predicate] count];
	STAssertTrue(i==1, @"There should be 1 SearchMo instances instead of %d", i);
}


/** 
 * Test searching with a predicate 
 */
- (void) test23SearchByFavorite {
	SearchMo *searchMo = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	searchMo.favorite = [NSNumber numberWithBool:YES];
	searchMo.jobs = nil;
	
	NSArray *array = [(SearchDao*)dao findByFavorite:[NSNumber numberWithBool:YES]];
	int i = [array count];
	STAssertTrue(i>0, @"There should be more than 0 SearchMo instances instead of %d", i);
}


/** 
 * Test creating a SearchMo with JobMo children 
 */
- (void) test24CreateWithChilds {
	JobMo *job1 = [jobDao jobWithName:@"Titulo blah 1" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob1"];
	job1.content = @"Sumario blah 1";
	job1.date = [NSDate date];
	JobMo *job2 = [jobDao jobWithName:@"Titulo blah 2" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob2"];
	job2.content = @"Sumario blah 2";
	job2.date = [NSDate date];
	NSSet *jobs = [NSSet setWithObjects: job1, job2, nil];

	SearchMo *searchMo = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	searchMo.favorite = [NSNumber numberWithBool:NO];
	searchMo.jobs = jobs;
	debug(@"searchMo: %@",[searchMo shortDescribe]);

	// check creation of 1 SearchMo
	NSArray *results = [dao objectsOfEntityName:NSStringFromClass([SearchMo class])];
	STAssertTrue([results count]==1, @"There should be 1 SearchMo instance instead of %d", [results count]);
	
	// check creation of 2 child jobs
	SearchMo *searchMo2 = [[dao objectsOfEntityName:NSStringFromClass([SearchMo class])] lastObject];
	STAssertTrue([searchMo2.jobs count]==2, @"There should be 2 job childs instead of %d", [searchMo2.jobs count]);
}


/** 
 * Check that removing the parent performs a cascade delete on the children. 
 */
- (void) test25CascadeChildRemoval {
	// create search with 2 children
	JobMo *job1 = [jobDao jobWithName:@"Titulo blah 1" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob1"];
	job1.content = @"Sumario blah 1";
	job1.date = [NSDate date];
	JobMo *job2 = [jobDao jobWithName:@"Titulo blah 2" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob2"];
	job2.content = @"Sumario blah 2";
	job2.date = [NSDate date];
	NSSet *jobs = [NSSet setWithObjects: job1, job2, nil];

	SearchMo *searchMo = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	searchMo.favorite = [NSNumber numberWithBool:NO];
	searchMo.jobs = jobs;

	// remove
	[dao remove:searchMo];
	
	// check children are gone
	int instances = [[jobDao objectsOfEntityName:NSStringFromClass([JobMo class])] count];
	STAssertTrue(instances==0, @"Deletion of related SearchMo left %d jobs behind.", instances);
}


/** 
 * Check that removing a child makes it disappear from the parent. 
 */
- (void) test26ChildRemoval {
	// create search with 2 children
	JobMo *job1 = [jobDao jobWithName:@"Titulo blah 1" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob1"];
	job1.content = @"Sumario blah 1";
	job1.date = [NSDate date];
	JobMo *job2 = [jobDao jobWithName:@"Titulo blah 2" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob2"];
	job2.content = @"Sumario blah 2";
	job2.date = [NSDate date];
	NSSet *jobs = [NSSet setWithObjects: job1, job2, nil];

	SearchMo *searchMo1 = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	searchMo1.favorite = [NSNumber numberWithBool:NO];
	searchMo1.jobs = jobs;
	
	[job1 addSearch:searchMo1];
	[job2 addSearch:searchMo1];
	
	// remove 1 child
	JobMo *job = [[jobDao objectsOfEntityName:NSStringFromClass([JobMo class])] lastObject];
	[jobDao remove:job];
	
	int jobNumber = [[jobDao objectsOfEntityName:NSStringFromClass([JobMo class])] count];
	STAssertTrue(jobNumber==1, @"There should be 1 job left instead %d.", jobNumber);
	
	// check SearchMo has exactly 1 child remaining
    SearchMo *searchMo2 = [[dao objectsOfEntityName:NSStringFromClass([SearchMo class])] lastObject];	
	STAssertTrue([searchMo2.jobs count]==1, @"There should be 1 job childs instead of %d", [searchMo2.jobs count]);	
}


- (void) test27CreateWithChildsAndCompany {
	
	// company
	CompanyMo *companyMo1 = [companyDao companyWithName:@"Acme Inc." andUrl:@"http://www.jobsket.es/trabajos/someCompany/"];
	companyMo1.latitude = [NSNumber numberWithFloat:(float)37.331689];
	companyMo1.longitude = [NSNumber numberWithFloat:(float)-122.030731];
	companyMo1.address = @"1 Infinite Loop, Cupertino, CA 95014";
	debug(@"companyMo1: %@",[companyMo1 describe]);

	CompanyMo *companyMo2 = [companyDao companyWithName:@"Acme Inc." andUrl:@"http://www.jobsket.es/trabajos/someCompany/"];
	companyMo2.latitude = [NSNumber numberWithFloat:(float)37.331689];
	companyMo2.longitude = [NSNumber numberWithFloat:(float)-122.030731];
	companyMo2.address = @"Microsoft Corporation, One Microsoft Way, Redmond, WA 98052-6399";
	debug(@"companyMo2: %@",[companyMo2 describe]);
	
	// jobs
	JobMo *job1 = [jobDao jobWithName:@"First job" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob1"];
	job1.company = companyMo1;
	job1.content = @"Content for the 1st job.";
	job1.date = [NSDate date];
	
	JobMo *job2 = [jobDao jobWithName:@"Second job" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob2"];
	job2.company = companyMo2;
	job2.content = @"Content for the 2nd job.";
	job2.date = [NSDate date];

	JobMo *job3 = [jobDao jobWithName:@"Third job" andUrl:@"http://www.jobsket.es/trabajo/someCompany/someJob3"];
	job3.company = companyMo2;
	job3.content = @"Content for the erd job.";
	job3.date = [NSDate date];
	
	NSSet *jobs = [NSSet setWithObjects: job1, job2, job3, nil];
	
	
	// search
	SearchMo *search = [(SearchDao*)dao searchWithUrl:@"http://www.jobsket.es/search?keywords=java"];
	search.favorite = [NSNumber numberWithBool:NO];
	search.jobs = jobs;
	
	debug(@"searchMo: %@",[search shortDescribe]);
	
	// check creation of 1 SearchMo
	NSArray *results = [dao objectsOfEntityName:NSStringFromClass([SearchMo class])];
	STAssertTrue([results count]==1, @"There should be 1 SearchMo instance instead of %d", [results count]);
	
	// check creation of 3 child jobs
	search = [[dao objectsOfEntityName:NSStringFromClass([SearchMo class])] lastObject];
	STAssertTrue([search.jobs count]==3, @"There should be 2 job childs instead of %d", [search.jobs count]);
	
	// check there are two different companies
	NSMutableSet *companies = [NSMutableSet setWithCapacity:2];
	NSEnumerator *enumerator = [search.jobs objectEnumerator];
	JobMo *item = nil;
	while (item = [enumerator nextObject]) {
		[companies addObject:item.company];
	}
	STAssertTrue([companies count]==2, @"There should be 2 different companies instead %d", [companies count]);
	
}



@end

