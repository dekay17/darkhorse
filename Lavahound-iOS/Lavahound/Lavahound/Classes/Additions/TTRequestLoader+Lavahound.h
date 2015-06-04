//
//  TTRequestLoader+Lavahound.h
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "Three20Network/private/TTRequestLoader.h"

extern NSString * const kLavahoundHttpErrorResponseDataKey;

@interface TTRequestLoader(Lavahound)
    
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end