//
//  NSDictionary+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NSDictionary+Lavahound.h"
#import "NSString+Lavahound.h"

@implementation NSDictionary(Lavahound)

- (NSString *)formatAsQueryString {
    if([self count] == 0)
        return @"";
    
    NSMutableString *queryString = [NSMutableString string];
    BOOL first = YES;
    
    for(id key in self) {
        NSString *keyAsString = [key description];
        NSString *valueAsString = [[self objectForKey:key] description];    
        [queryString appendFormat:@"%@%@=%@", first ? @"?" : @"&", [keyAsString urlEncode], [valueAsString urlEncode]];        
        first = NO;
    }
    
	return queryString;
}

@end