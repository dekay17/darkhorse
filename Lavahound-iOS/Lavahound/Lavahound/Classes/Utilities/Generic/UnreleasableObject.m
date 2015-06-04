//
//  UnreleasableObject.m
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UnreleasableObject.h"

@implementation UnreleasableObject

#pragma mark -
#pragma mark NSObject

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (void)release {}

- (id)autorelease {
	return self;
}

@end