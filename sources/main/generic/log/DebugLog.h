
/* 
 * @author Karl Kraft
 * See http://www.karlkraft.com/index.php/2009/03/23/114/
 */

#import <Foundation/Foundation.h>

// FOR RELEASE ON THE APP STORE, THE NEXT TWO LINES SHOULD BE COMMENTED

#define WARN
#define DEBUG

#ifdef DEBUG
    #define debug(args...) _Log(@"", 50, __FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
    #define debug(x...)
#endif

#ifdef WARN
    #define warn(args...) _Log(@"WARNING ", 50, __FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
    #define warn(x...)
#endif

void _Log(NSString *prefix, int padding, const char *file, int lineNumber, const char *funcName, NSString *format,...);


