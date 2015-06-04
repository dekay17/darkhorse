//
//  NSString+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NSString+Lavahound.h"

@implementation NSString(Lavahound)

- (NSString *)urlEncode {
    NSString *urlEncodedString =
        (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                            (CFStringRef) self,
                                                            NULL,
                                                            (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                            kCFStringEncodingUTF8);
    return [urlEncodedString autorelease];
}

- (NSString *)urlDecode {
    NSString *urlDecodedString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    urlDecodedString = [urlDecodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];   
    return urlDecodedString;
}

+ (NSString *)GetUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

@end