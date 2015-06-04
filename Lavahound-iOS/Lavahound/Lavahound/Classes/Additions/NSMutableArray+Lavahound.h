//
//  NSMutableArray+Lavahound.h
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Lavahound)

// Simple way to create non-retaining arrays
// Thanks to http://stackoverflow.com/questions/4692161/non-retaining-array-for-delegates
+ (id)mutableArrayUsingWeakReferences;
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end