//
//  User.h
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface User : NSObject {
    NSNumber *_userId;
    NSString *_emailAddress;
    NSString *_displayName;
    NSString *_imageUrl;    
    NSNumber *_photosHidden;
    NSNumber *_timesFound;
    NSString *_rank;
}

+ (User *)userFromJson:(NSDictionary *)userJson;

@property(nonatomic, retain) NSNumber *userId;
@property(nonatomic, copy) NSString *emailAddress;
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, retain) NSNumber *photosHidden;
@property(nonatomic, retain) NSNumber *timesFound;
@property(nonatomic, copy) NSString *rank;

@end