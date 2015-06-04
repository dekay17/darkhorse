//
//  NSMutableArray+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NSMutableArray+Lavahound.h"

@implementation NSMutableArray(Lavahound)

// Thanks to http://stackoverflow.com/questions/4692161/non-retaining-array-for-delegates

+ (id)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end