
#import "XPathQuery.h"

#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>


NSDictionary *DictionaryForNode(xmlNodePtr currentNode, NSMutableDictionary *parentResult) {
    NSMutableDictionary *resultForNode = [NSMutableDictionary dictionary];
	
    if (currentNode->name) {
        NSString *currentNodeContent =
		[NSString stringWithCString:(const char *)currentNode->name encoding:NSUTF8StringEncoding];
        [resultForNode setObject:currentNodeContent forKey:@"nodeName"];
    }
	
    if (currentNode->content && currentNode->type != XML_DOCUMENT_TYPE_NODE) {
        NSString *currentNodeContent =
		[NSString stringWithCString:(const char *)currentNode->content encoding:NSUTF8StringEncoding];
		
        if ([[resultForNode objectForKey:@"nodeName"] isEqual:@"text"] && parentResult) {
            currentNodeContent = [currentNodeContent
                                  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
            NSString *existingContent = [parentResult objectForKey:@"nodeContent"];
            NSString *newContent;
            if (existingContent) {
                newContent = [existingContent stringByAppendingString:currentNodeContent];
            }
            else {
                newContent = currentNodeContent;
            }
			
            [parentResult setObject:newContent forKey:@"nodeContent"];
            return nil;
        }
		
        [resultForNode setObject:currentNodeContent forKey:@"nodeContent"];
    }
	
    xmlAttr *attribute = currentNode->properties;
    if (attribute) {
        NSMutableArray *attributeArray = [NSMutableArray array];
        while (attribute) {
            NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
            NSString *attributeName =
			[NSString stringWithCString:(const char *)attribute->name encoding:NSUTF8StringEncoding];
            if (attributeName) {
                [attributeDictionary setObject:attributeName forKey:@"attributeName"];
            }
			
            if (attribute->children) {
                NSDictionary *childDictionary = DictionaryForNode(attribute->children, attributeDictionary);
                if (childDictionary) {
                    [attributeDictionary setObject:childDictionary forKey:@"attributeContent"];
                }
            }
			
            if ([attributeDictionary count] > 0) {
                [attributeArray addObject:attributeDictionary];
            }
            attribute = attribute->next;
        }
		
        if ([attributeArray count] > 0) {
            [resultForNode setObject:attributeArray forKey:@"nodeAttributeArray"];
        }
    }
	
    xmlNodePtr childNode = currentNode->children;
    if (childNode) {
        NSMutableArray *childContentArray = [NSMutableArray array];
        while (childNode) {
            NSDictionary *childDictionary = DictionaryForNode(childNode, resultForNode);
            if (childDictionary) {
                [childContentArray addObject:childDictionary];
            }
            childNode = childNode->next;
        }
        if ([childContentArray count] > 0) {
            [resultForNode setObject:childContentArray forKey:@"nodeChildArray"];
        }
    }
	
    return resultForNode;
}


NSArray *PerformXPathQuery(xmlDocPtr doc, NSString *query) {
    xmlXPathContextPtr xpathCtx;
    xmlXPathObjectPtr xpathObj;
	
    // create xpath evaluation context
    xpathCtx = xmlXPathNewContext(doc);
    if (xpathCtx == NULL) {
        warn(@"Unable to create XPath context.");
        return nil;
    }
	
    // evaluate xpath expression
    xpathObj = xmlXPathEvalExpression( (xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding], xpathCtx );
    if (xpathObj == NULL) {
        warn(@"Unable to evaluate XPath.");
        return nil;
    }
	
    xmlNodeSetPtr nodes = xpathObj->nodesetval;
    if (!nodes) {
        warn(@"Nodes was nil.");
		// cleanup
		xmlXPathFreeObject(xpathObj); 
		xmlXPathFreeContext(xpathCtx);
        return nil;
    }
	
    NSMutableArray *resultNodes = [NSMutableArray array];
    for (NSInteger i = 0; i < nodes->nodeNr; i++) {
        NSDictionary *nodeDictionary = DictionaryForNode(nodes->nodeTab[i], nil);
        if (nodeDictionary) {
            [resultNodes addObject:nodeDictionary];
        }
    }
	
    // cleanup
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
	
    return resultNodes;
}


/**
 * PerformXMLXPathQuery.
 *
 * This function returns a NSArray whose elements are nodes resulting from 
 * running the XPath expression on the given document.
 *
 * Each of the elements is a NSDictionary with the following key/values:
 * 
 * - nodeName: Name of the node as a NSString.
 *
 * - nodeAttributeArray: Attributes of the node. 
 *                       It's a NSArray of NSDictionary where each dictionary has these key/values:
 *                           - attributeName: Name of the attribute as a NSString.
 *                           - nodeContent: Content of the attribute as a NSString.
 * 
 * - nodeChildArray: Child nodes. Same structure as the root node.
 * 
 * - nodeContent: Content of the node as a NSString.
 *
 */
NSArray *PerformHTMLXPathQuery(NSData *document, NSString *query) {

    // load XML document
    xmlDocPtr doc = htmlReadMemory([document bytes], [document length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);

    if (doc == NULL) {
        warn(@"Unable to parse.");
        return nil;
    }

    NSArray *result = PerformXPathQuery(doc, query);
    xmlFreeDoc(doc);

    return result;
}


NSArray *PerformXMLXPathQuery(NSData *document, NSString *query) {

    // Load XML document
    xmlDocPtr doc = xmlReadMemory([document bytes], [document length], "", NULL, XML_PARSE_RECOVER);

    if (doc == NULL) {
        warn(@"Unable to parse.");
        return nil;
    }

    NSArray *result = PerformXPathQuery(doc, query);
    xmlFreeDoc(doc);

    return result;
}




// Next two functions add the ability to use the XPath count function.


NSInteger CountXPathNodes(xmlDocPtr doc, NSString *query) {
    xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
    if (xpathCtx == NULL) {
        warn(@"Unable to create XPath context.");
        return NSNotFound;
    }
    xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression( (xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding], xpathCtx );
    if (xpathObj == NULL) {
        warn(@"Unable to evaluate XPath.");
        return NSNotFound;
    }
    NSInteger count = 0;
    if (xpathObj->type == XPATH_NUMBER) {
        count = xmlXPathCastToNumber(xpathObj);
    }
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    return count;
}


NSInteger CountNodes(NSData *document, NSString *query) {
    xmlDocPtr doc = xmlReadMemory([document bytes], [document length], "", NULL, XML_PARSE_RECOVER);
    if (doc == NULL) {
        warn(@"Unable to parse.");
        return NSNotFound;
    }
    NSInteger result = CountXPathNodes(doc, query);
    xmlFreeDoc(doc);
    return result;
}
