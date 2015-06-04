//
//  NSURL+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NSURL+Lavahound.h"
#import "NSString+Lavahound.h"

@implementation NSURL(Lavahound)

- (NSDictionary *)parameters {
    NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];  
    NSString *urlString = [self absoluteString];  
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"?"];
    
    if([urlComponents count] > 1) {
        NSString *query = [urlComponents lastObject];    
        NSArray *queryElements = [query componentsSeparatedByString:@"&"];
        
        for (NSString *element in queryElements) {
            NSArray *keyAndValue = [element componentsSeparatedByString:@"="];
            NSString *key = [keyAndValue objectAtIndex:0];
            NSString *value = [keyAndValue lastObject];      
            [parameters setObject:[value urlDecode] forKey:key];
        }    
    }
    
    return parameters;
}

@end