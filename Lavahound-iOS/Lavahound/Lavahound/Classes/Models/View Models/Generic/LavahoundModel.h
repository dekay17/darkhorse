//
//  LavahoundModel.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface LavahoundModel : TTURLRequestModel {}

- (void)processResponse:(NSDictionary *)json;

@property(nonatomic, readonly) NSString *relativeUrl;
@property(nonatomic, readonly) NSDictionary *parameters;
@property(nonatomic, readonly) TTURLRequestCachePolicy cachePolicy;

@end


@protocol ListableModel <NSObject>

@property (nonatomic, readonly) NSArray *items;

@end