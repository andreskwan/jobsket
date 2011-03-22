
#import "Mo.h"

@implementation Mo


-(BOOL) isValid {
	return TRUE;
}



-(NSString *) jsonDocument {
    return [NSString stringWithFormat:@"{\n %@ \n}",[self json]];
}


-(NSString *) json {
	return [self json:0];
}


-(NSString *) json:(int)i {
    return [self jsonForKeys:[self keys] index:i];
}


-(NSString *) jsonForKeys:(NSArray*)keys index:(int)i {
	
	NSMutableString *json;
	if (i>0) json = [NSMutableString stringWithFormat:@"\"%@%d\":{",[self class],i];
	else json = [NSMutableString stringWithFormat:@"\"%@\":{",[self class]];
	
	NSMutableArray *array = [NSMutableArray new];
	
	/*NSSet *supportedClasses = [NSSet setWithObjects:
							   @"NSString", @"NSNumber", @"NSDate", @"NSSet", 
							   @"SearchMo", @"CompanyMo", @"JobMo"];*/
	
	// iterate over variables
	for (NSString *key in keys) {
		id value = [self valueForKey:key];
		if (value) {
			if ([value isKindOfClass:[NSSet class]]){
				
				NSMutableString *stringSet = [NSMutableString stringWithFormat:@"\"%@\":{",key];
				NSMutableArray *objectElements = [NSMutableArray new];
				
				int i = 1;
				for (id obj in (NSSet*)value) {
					if (obj) {
						if ([obj isKindOfClass:[Mo class]]){
							[objectElements addObject:[(Mo*)obj json:i]];
							i++;
						} else {
							debug(@"object from set not a mo class: %@", [self class]);
						}						
					}
				}
				
				[stringSet appendString:[objectElements componentsJoinedByString:@","]];
				[stringSet appendString:@"}"];
				[array addObject:stringSet];
				[objectElements release];
                
			} else if ([value isKindOfClass:[Mo class]]){
				[array addObject:[(Mo*)value json]];
			} else {
				//debug(@"Not a set or mo: %@", [value class]);
				if ([key isEqualToString:@"latitude"] 
					|| [key isEqualToString:@"longitude"]
					|| [key isEqualToString:@"maxSalary"]
					|| [key isEqualToString:@"minSalary"]
					|| [key isEqualToString:@"favorite"]
				    ){
					[array addObject:[NSString stringWithFormat:@" \"%@\":%@", key, value]];
				} else {
					[array addObject:[NSString stringWithFormat:@" \"%@\":\"%@\"", key, value]];
				}

			}
		}
		
	}
	[json appendFormat:@"%@",[array componentsJoinedByString:@","]];
	
	[json appendString:@"}"];
    
    [array release];
	return json;
}


-(NSArray*) keys {
	return [NSArray array];
}


-(NSString *) describe {
	return [self json];
}



@end
