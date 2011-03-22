
#include "DebugLog.h"


// const char *prefix, int padding, 
void _Log(NSString *prefix, int padding, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
	
	//return;
	
	// if output is only one \n, just print that and exit
	if ([format isEqualToString:@"\n"]){
		fprintf(stderr,"\n");
		return;
	}
	
    va_list ap;
    va_start (ap, format);
	
	// Add trailing newline if not present. 
	// We are using "line buffering" (I think) so the buffer flush on any \n character.
    if (![format hasSuffix:@"\n"]) {  
		format = [format stringByAppendingString:@"\n"];
    }

	NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
	
    va_end (ap);
	
	// OUTPUT: -[SomeClass testSharedInstance]:13 - lalalalalalalalalala
	fprintf(stderr,"%s%50s:%3d - %s",[prefix UTF8String], funcName, lineNumber, [msg UTF8String]);

    [msg release];
}

