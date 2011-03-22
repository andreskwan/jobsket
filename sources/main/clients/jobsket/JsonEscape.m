
#import "JsonEscape.h"

@implementation JsonEscape

@synthesize htmlEntities;


- (id) init {
	self = [super init];
	if (self != nil){
		// http://www.w3schools.com/tags/ref_entities.asp
		htmlEntities = [NSDictionary dictionaryWithObjectsAndKeys:
						@"Á", @"&Aacute;",  @"á", @"&aacute;",
						@"É", @"&Eacute;",  @"é", @"&eacute;",
						@"Í", @"&Iacute;",  @"í", @"&iacute;",
						@"Ó", @"&Oacute;",  @"ó", @"&oacute;",
						@"Ú", @"&Uacute;",  @"ú", @"&uacute;",
						@"Ü", @"&Uuml;",    @"ü", @"&uuml;",
						
						@"Á", @"&#193;",    @"á", @"&#225;", 
						@"É", @"&#201;",    @"é", @"&#233;", 
						@"Í", @"&#205;",    @"í", @"&#237;", 
						@"Ó", @"&#211;",    @"ó", @"&#243;", 
						@"Ú", @"&#218;",    @"ú", @"&#250;", 
						@"Ü", @"&#220;",    @"ü", @"&#252;", 
						
						@"©", @"&copy;",    @"®", @"&reg;",
						@"¿", @"&iquest;",  @"\"",@"&quot;",
						nil];
	}
	return self;
}


-(NSString*) replaceEntities:(NSString*) unsafeText {
	NSMutableCharacterSet *safeSet = [NSMutableCharacterSet alphanumericCharacterSet];
	[safeSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
	[safeSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	//[safeSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
	
	NSMutableString *result = [NSMutableString new];
    for (int i = 0; i < [unsafeText length]; i++) {
		unichar c = [unsafeText characterAtIndex:i];
		if (c=='&'){
			// found possible entity start
			int maxSizeOfAnEntity = 8;
			for (int j=i; j<i+maxSizeOfAnEntity+1; j++) { 
				// if inside string limits
				if (j<[unsafeText length]){ 
					unichar x = [unsafeText characterAtIndex:j];
					if (x==';'){
						// found possible entity finish
						NSRange range = NSMakeRange(i, j-i+1);
						NSString *possibleEntity = [unsafeText substringWithRange:range];
						NSString *replacement = [htmlEntities objectForKey:possibleEntity];
						if (replacement){
							// add replacement and advance cursor
							[result appendString:replacement];
							i=j;
						}
					}
				}
			}
			
		} else {
			[result appendFormat:@"%C",c];
		} 
		
	}	
	return [result autorelease];
}


-(NSString*) replaceEntitiesAndEscape:(NSString*)unsafeText {
	NSMutableCharacterSet *safeSet = [NSMutableCharacterSet alphanumericCharacterSet];
	[safeSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
	[safeSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	//[safeSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
	
	NSMutableString *result = [NSMutableString new];
    for (int i = 0; i < [unsafeText length]; i++) {
		unichar c = [unsafeText characterAtIndex:i];
		
		// replace html entities
		if (c=='&'){
			// found possible entity start
			int maxSizeOfAnEntity = 8;
			for (int j=i; j<i+maxSizeOfAnEntity+1; j++) { 
				// if inside string limits
				if (j<[unsafeText length]){ 
					unichar x = [unsafeText characterAtIndex:j];
					if (x==';'){
						// found possible entity finish
						NSRange range = NSMakeRange(i, j-i+1);
						NSString *possibleEntity = [unsafeText substringWithRange:range];
						NSString *replacement = [htmlEntities objectForKey:possibleEntity];
						if (replacement){
							// add replacement and advance cursor
							[result appendString:replacement];
							i=j;
						}
					}
				}
			} 
			
		// dropping below 0x20. See https://github.com/johnezang/JSONKit/blob/master/JSONKit.m
		} else if (c < 0x20UL){
			[result appendString:@" "];
			
		// escape double quote
	    } else if (c=='"'){
			[result appendString:@"\\\""];
			
		// escape left bar
	    } else if (c=='\\'){
			[result appendString:@"-"];
			
		// accept
		} else if ([safeSet characterIsMember:c]){
			[result appendFormat:@"%C",c];
			
		// drop
		} else {
		}
		
	}	
	return [result autorelease];
}


-(NSString*) escape:(NSString*)unsafeText {
	NSMutableCharacterSet *safeSet = [NSMutableCharacterSet alphanumericCharacterSet];
	[safeSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
	[safeSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
	NSMutableString *result = [NSMutableString new];
    for (int i = 0; i < [unsafeText length]; i++) {
		unichar c = [unsafeText characterAtIndex:i];
		
		// escape double quote
		if (c=='"'){
			[result appendString:@"\\\""];
			
		// escape left bar
	    } else if (c=='\\'){
			[result appendString:@"-"];
		
		} else if (c==' '){
			if ((i+1<[unsafeText length]) && ([unsafeText characterAtIndex:i+1]==' ')){
				// skip. This prevents inclusion of two consecutive spaces.
			} else {
				[result appendString:@" "];
			}
			
		// accept
		} else if ([safeSet characterIsMember:c]){
			[result appendFormat:@"%C",c];
			
		// drop
		} else {
		}
		
	}	
	return [result autorelease];
}


@end
