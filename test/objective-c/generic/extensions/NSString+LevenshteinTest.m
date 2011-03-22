
#import "NSString+Levenshtein.h"

@interface NSString_LevenshteinTest : GHTestCase {	
}
@end


@implementation NSString_LevenshteinTest

- (void) setUp {
	[super setUp];
}

- (void) test1Levenshtein {
	NSArray *badNames = [NSArray arrayWithObjects:@"PAGE PERSONNEL SELECCIÓN, S.A.", @"Avanzza S.Coop.", @"Amplía Soluciones S.L.", 
							  @"Enxendra Technologies", @"Graciela Cardinale", @"idealista, libertad y control, s.a.", @"Ceromat SL", 
							  @"Original Zone of Market, S.L.", @"BIKO2 2006, S.L.", @"Baratz", @"Aubergin Tecnologies S.l", 
							  @"Blackslot SL", nil];
	
	NSArray *okNames = [NSArray arrayWithObjects:@"Page Personnel Selección", @"Avanzza", @"Amplía Soluciones", @"Enxendra", @"CARDI TI", 
						@"idealista.com", @"Cermomat", @"Orizom", @"Biko", @"Aubergin", @"Blackslot", nil];
	
	for (NSString *okName in okNames) {	
		NSString *okLowercase = [okName lowercaseString];
		NSString *badLowercase;
		for (NSString *badName in badNames) {
			badLowercase = [badName lowercaseString];
			//debug(@"  word: %@ vs %@ = %f", one, two, [one compareWithWord:two]);
			if ([okLowercase compareWithString:badLowercase]<2)
			    debug(@"string: %@ vs %@ = %f", okLowercase, badLowercase, [okLowercase compareWithString:badLowercase]);
		}
		debug(@"\n");
	}
		
	GHAssertTrue(TRUE, nil);
}

@end
