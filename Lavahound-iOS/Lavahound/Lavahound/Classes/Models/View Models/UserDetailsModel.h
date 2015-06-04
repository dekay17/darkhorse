//
//  UserDetailsModel.h
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"
#import "User.h"

@interface UserDetailsModel : LavahoundModel {
    User *_user;
    NSNumber *_userId;
}

// This isn't used now but will be once we start loading up other users' profiles
- (id)initWithUserId:(NSNumber *)userId;

@property(nonatomic, readonly) User *user;

@end