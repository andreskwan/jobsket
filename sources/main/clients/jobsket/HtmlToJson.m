
#import "HtmlToJson.h"


@implementation HtmlToJson



- (NSString *) jsonJobDetailFromData:(NSData *)htmlSearchData {
    NSString *xpath = @"//div[@id='joboffer']/p";
    NSArray *nodesArray = PerformHTMLXPathQuery(htmlSearchData, xpath);

	NSMutableArray *elements = [NSMutableArray new];
	
    NSDictionary *dict;
	
	JsonEscape *je = [JsonEscape new];
	
    if (0<[nodesArray count]) {
	dict = [nodesArray objectAtIndex:0];
        NSString *reference = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n       \"reference\" : \"%@\" ", reference]];
    }
	
    if (1<[nodesArray count]) {
	dict = [nodesArray objectAtIndex:1];
        NSString *category = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n        \"category\" : \"%@\" ", category]];
    }
	
    if (2<[nodesArray count]) {
		dict = [nodesArray objectAtIndex:2];
        NSString *city = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n            \"city\" : \"%@\" ", city]];
    }
	
    if (3<[nodesArray count]) {
		    dict = [nodesArray objectAtIndex:3];
        NSString *place = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n           \"place\" : \"%@\" ", place]];
    }
	
    if (5<[nodesArray count]) {
		dict = [nodesArray objectAtIndex:5];
        NSString *content = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n     \"content\" : \"%@\" ", content]];
    }

    if (7<[nodesArray count]) {
		dict = [nodesArray objectAtIndex:7];
        NSString *requirements = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n    \"requirements\" : \"%@\" ", requirements]];
    }

    if (9<[nodesArray count]) {
		dict = [nodesArray objectAtIndex:9];
        NSString *experience = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n      \"experience\" : \"%@\" ", experience]];
    }

    if (11<[nodesArray count]) {
		dict = [nodesArray objectAtIndex:11];
        NSString *other = [je replaceEntitiesAndEscape:[dict objectForKey:@"nodeContent"]];
        [elements addObject:[NSString stringWithFormat:@"\n           \"other\" : \"%@\" ", other]];
    }

	NSString *json = [NSString stringWithFormat:@"{ %@ \n}", [elements componentsJoinedByString:@","]];
    [je release];
    [elements release];
    
    return json;
}



-(NSString*) jsonJobsFromData:(NSData *)htmlSearchData {
	
	JsonEscape *je = [JsonEscape new];
	
	NSString *xpath = @"//div[@class='jobs']/div[@class='job']";
	NSArray *nodesArray = PerformHTMLXPathQuery(htmlSearchData, xpath);
	
	debug(@"    XPath: %d nodes from HTML", [nodesArray count]);
	
	NSMutableArray *jobs = [NSMutableArray new];
	
    // iterating over nodes
	NSMutableString *json;
	for (int i=0; i<[nodesArray count]; i++) {
		json = [[NSMutableString new] autorelease];
		[json appendFormat:@"\n\t\"JobMo%d\": \n\t{",i];
		NSMutableArray *jobElements = [NSMutableArray new];
		NSDictionary *nodesDict = [nodesArray objectAtIndex:i];
		NSArray *nodesArray2 = [nodesDict objectForKey:@"nodeChildArray"]; 
		for (int i2=0; i2<[nodesArray2 count]; i2++) {
			NSDictionary *nodesDict2 = [nodesArray2 objectAtIndex:i2];
			NSArray *nodesAttrDict2 = [nodesDict2 objectForKey:@"nodeAttributeArray"];
			for (int i3=0; i3<[nodesAttrDict2 count]; i3++) {
				NSDictionary *nodesAttrDict3 = [nodesAttrDict2 objectAtIndex:i3];
				NSString *divClass = [nodesAttrDict3 objectForKey:@"nodeContent"];
				NSArray *arrayDict3 = [nodesDict2 objectForKey:@"nodeChildArray"];
				
				// DIV CLASS="TITLE"
				if ([divClass isEqualToString:@"title"]){
					for (int i4=0; i4<[arrayDict3 count]; i4++) {
						
						// <A HREF="url">name</a>
						NSDictionary *dict4 = [arrayDict3 objectAtIndex:i4];
						NSString *name = [je replaceEntitiesAndEscape:[dict4 objectForKey:@"nodeContent"]];
						[jobElements addObject:[NSString stringWithFormat:@"\n\t\t\"title\":\"%@\"", name] ];
						NSArray *nodesAttrDict4 = [dict4 objectForKey:@"nodeAttributeArray"];
						NSDictionary *attributes4 = [nodesAttrDict4 lastObject];
						NSString *url = [je replaceEntitiesAndEscape:[attributes4 objectForKey:@"nodeContent"]];
						[jobElements addObject:[NSString stringWithFormat:@"\n\t\t\"url\":\"%@%@\"",@"http://www.jobsket.es", url]];
					}
					
				// DIV CLASS="JOBINFO"
				} else if ([divClass isEqualToString:@"jobinfo"]){
					NSMutableArray *companyElements = [NSMutableArray new];
					NSString *company = [NSMutableString new];
                    [company autorelease];
					for (int i4=0; i4<[arrayDict3 count]; i4++) {
						NSDictionary *dict4 = [arrayDict3 objectAtIndex:i4];
						NSArray *attribute = [dict4 objectForKey:@"nodeAttributeArray"];
						if (attribute) {
							NSDictionary *dict5 = [attribute lastObject];
							NSString *attributeName = [dict5 objectForKey:@"attributeName"];
							
							// <A HREF="url">name</a>
							if ([attributeName isEqualToString:@"href"]){
								
								NSString *name = [je replaceEntitiesAndEscape:[dict4 objectForKey:@"nodeContent"]];
								NSString *url = [je replaceEntitiesAndEscape:[dict5 objectForKey:@"nodeContent"]];
								
								[companyElements addObject:[NSString stringWithFormat:@"\n\t\t\t\"name\":\"%@\"",name]];
								[companyElements addObject:[NSString stringWithFormat:@"\n\t\t\t\"url\":\"%@%@\"", @"http://www.jobsket.es", url]];
								company = [companyElements componentsJoinedByString:@","];
							
							// <SPAN CLASS="PLACE">location - date</SPAN>
							} else if ([attributeName isEqualToString:@"class"]){
								NSArray *split = [[dict4 objectForKey:@"nodeContent"] componentsSeparatedByString:@"-"];
								
								// escape location
								NSString *location = [je replaceEntitiesAndEscape:[[split objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								
								[jobElements addObject:[NSString stringWithFormat:@"\n\t\t\"location\":\"%@\"", location]];
								[jobElements addObject:[NSString stringWithFormat:@"\n\t\t\"date\":\"%@\"", [[split objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
							}
						}
					}
					[jobElements addObject:[NSString stringWithFormat:@"\n\t\t\"CompanyMo\":\n\t\t{%@\n\t\t}",company]];
					[companyElements release];
                    
				// DIV CLASS="CONTENT"
				} else if ([divClass isEqualToString:@"content"]){
				
					NSString *content = [je replaceEntitiesAndEscape:[nodesDict2 objectForKey:@"nodeContent"]];
					[jobElements addObject:[NSString stringWithFormat:@"\n\t\t\"content\": \"%@\"", content]];
					
				} else if ([divClass isEqualToString:@"quotes"]){
				}
			}
		}
		[json appendString:[jobElements componentsJoinedByString:@","]];
		[json appendString:@"\n\t}"];
        [jobElements release];
		[jobs addObject:json];
	}
	
	NSString *result = [NSString stringWithFormat:@"\n{\n%@\n}", [jobs componentsJoinedByString:@","]];
//    [json release];
	debug(@"    HTML to JSON: %d characters", [result length]);
    [jobs release];
    [je release];
	return result;
}


@end




/* See http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html
 
 The root node returned is an array of NSDictionary objects with the following key/values:
 
     - nodeName: Name of the node as a NSString.
 
     - nodeAttributeArray: Attributes of the node. 
                           It's a NSArray of NSDictionary where each dictionary has these key/values:
                             - attributeName: Name of the attribute as a NSString.
                             - nodeContent: Content of the attribute as a NSString.
 
     - nodeChildArray: Child nodes. Same structure as the root node.
 
     - nodeContent: Content of the node as a NSString.
*/


/*
 "JobMo1":
 {
 "url":"http://www.jobsket.es/trabajo/original-zone-of-market-sl/analista_programador_en_java",
 "content":"Summary for the erd job.",
 "name":"Third job",
 "CompanyMo":
 {
 "url":"http://www.jobsket.es/trabajos/enxendra-technologies",
 "name":"Acme Inc.",
 "address":"Microsoft Corporation, One Microsoft Way, Redmond, WA 98052-6399",
 "latitude":37.33169,
 "longitude":-122.0307
 }
 },
 */



/*
 
<html>
    <body>
		<div id="container">
			<div id="contentwrapper">
				<div id="rowrap5" class="con">
 
					<div class="jobs">
 
						<div class="job">
 
							<div class="title">
								<a href="/trabajo/amplia-soluciones-sl/analista_programador_java">Analista Programador Java</a>
							</div>
 
							<div class="jobinfo">
								<b>Company:</b> <a href="/trabajos/amplia-soluciones-sl">Ampl&#195;&#173;a Soluciones S.L.</a>
                                <br />
								<span class="place">Madrid - 22/10/2010</span>
                                <br />
							</div>
 
							<div class="content">
								El candidato se integrar&#195;&#161; en un equipo de Ingenier&#195;&#173;a de Software 
                                para el desarrollo de nuestro producto OpenGate (http://www.opengate.es), y de sus 
								integraciones en la arquitectura de sistemas de nuestros clientes. Su responsabilidad 
								ser&#195;&#161; la de analizar los requisitos de cliente, darles forma en la
							</div>
 
							<div class="quotes"></div>
						</div>
 
					</div>
 
				</div>
			</div>
		</div>
    </body>
</html>

*/