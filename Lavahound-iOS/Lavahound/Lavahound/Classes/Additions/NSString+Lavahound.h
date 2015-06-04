//
//  NSString+Lavahound.h
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Lavahound)

- (NSString *)urlEncode;
- (NSString *)urlDecode;
+ (NSString *)GetUUID;

@end