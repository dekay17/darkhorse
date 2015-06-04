//
//  NSData+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NSData+Lavahound.h"

@implementation NSData(Lavahound)

- (NSString *)description {
    // Default behavior is to dump out every single byte - just show number of bytes instead.
    return [NSString stringWithFormat:@"<%lu bytes>", [self length]];
}

@end