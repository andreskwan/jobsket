
#import <GHUnitIOS/GHUnitIOS.h>
#import "JsonMoBuilder.h"
#import "BundleFile.h"
#import "Query.h"
#import "JobMo.h"

#import "RegexKitLite.h"
#import "GTMNSString+HTML.h"

@interface JsonMoBuilderTest : GHTestCase {	
}
@end


@implementation JsonMoBuilderTest

- (void) setUp {
	[super setUp];
}


-(void) test1ParseJob {
	
    NSString *json = [[[BundleFile alloc] initWithFilename:@"job-184" andExtension:@"json"] string];
	JsonMoBuilder *jmb = [[JsonMoBuilder alloc] init];
	JobMo *job = [jmb parseJob:json];
	NSString *content = job.content;
	debug(@"job.content = %@", content);
	
	NSString *result = [content stringByReplacingOccurrencesOfRegex:@"\\<.*?>"
                                                         withString:@""];
	debug(@"stripped from tags: '%@'", result);
	
	debug(@"\n");
	debug(@"#######################################################################################");
	debug(@"\n");
	
	debug(@"unescaped: '%@'", [result gtm_stringByUnescapingFromHTML]);
}


-(void) test2Unescape {
	NSString *text = @" &oacute; ";
	debug(@"%@ = %@", text, [text gtm_stringByUnescapingFromHTML]);

}


-(void) test3split {
	/*
	NSString *description;
	NSString *requirements;
	NSString *experience;
	NSString *other;
	*/
	
	NSString *content = @" \
	    <p class=\"jobsectioncontent\"> \
		\tAubergin Tecnologies S.L precisa para un importante proyecto ubicado en Alicante.\r<br/> \
		\r<br/>JEFE DE EQUIPO TEST y CALIDAD DE SOFTWARE.\r<br/>\r<br/>\r<br/>\r<br/>\r<br/></p> \
	    \
        <p class=\"jobsection\">Requerimientos:</p> \
        <p class=\"jobsectioncontent\">\tExperiencia en Planificación y gestión de pruebas; \
	    Metodologías de desarrollo; UML; Arquitectura Java; Gestión de equipos\r<br/>Buen nIvel \
	    de Ingles. \r<br/> \r<br/> \r<br/></p> \
	    \
        <p class=\"jobsection\">Experiencia:</p> \
        <p class=\"jobsectioncontent\">\tDe 5 a 10 años de experiencia</p> \
	    \
        <p class=\"jobsection\">Otros:</p> \
        <p class=\"jobsectioncontent\">\t</p>";                   
	
	// reduce consecutive spaces to one
	//content = [content stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
	
	//NSRange range = [content rangeOfString:@"<p class=\"jobsection\">Requerimientos:</p>"];
	//debug(@"location=%d, length=%d", range.location, range.length);
	
	// breakdown the string
	NSScanner *scanner = [NSScanner scannerWithString:content];
	NSString *description;
	NSString *requirements;
	NSString *experience;
	NSString *other;
	[scanner scanUpToString:@"<p class=\"jobsection\">Requerimientos:</p>" intoString:&description];
	[scanner scanUpToString:@"<p class=\"jobsection\">Experiencia:</p>" intoString:&requirements];
	[scanner scanUpToString:@"<p class=\"jobsection\">Otros:</p>" intoString:&experience];
	other = [content substringFromIndex:[scanner scanLocation]];
	
	// strip tags
	description = [[description stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
	requirements = [[requirements stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
	experience = [[experience stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
	other = [[other stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];

    requirements = [requirements stringByReplacingOccurrencesOfString:@"Requerimientos:" withString:@""];
    experience = [experience stringByReplacingOccurrencesOfString:@"Experiencia:" withString:@""];
    other = [other stringByReplacingOccurrencesOfString:@"Otros:" withString:@""];

	description = [description stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
	requirements = [requirements stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
	experience = [experience stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
	other = [other stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
	
	// strip newlines
	debug(@"%@", [description stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
	debug(@"%@", [requirements stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
	debug(@"%@", [experience stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
	debug(@"%@", [other stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);

}


@end
