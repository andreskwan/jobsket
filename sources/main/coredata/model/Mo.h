
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>


@interface Mo : NSManagedObject {

}

/** Return true if object doesn't have any nil mandatory field. */
-(BOOL) isValid;



/** 
 * Return a string representation of the object. 
 * The properties in the string representation are those returned by [self keys].
 */
-(NSString *) describe;


#pragma mark JSON stuff

-(NSString *) jsonDocument;

/** 
 * Return a JSON object for the given keys.
 * Each key should be a property of this object.
 */
-(NSString *) jsonForKeys:(NSArray*)keys index:(int)i;


/** 
 * Return an array of NSString. 
 * Each string is the name of a property of this ManagedObject.
 */
-(NSArray*) keys;


/**
 * Return a JSON representation of this object.
 * The properties in the JSON representation are those returned by [self keys].
 */
-(NSString *) json;


-(NSString *) json:(int)i;


@end
