//
//  ScoreboardData.h
//  Lavahound
//
//  Created by Russak Nathan on 3/13/12.
//  Copyright (c) 2012 LavaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreboardData : NSObject

@property (nonatomic, readonly) int         Id;
@property (nonatomic, readonly) int         Place;
@property (nonatomic, readonly) NSString *  Name;
@property (nonatomic, readonly) int         Score;
@property (nonatomic, readonly) BOOL        IsUser;

- (id) initWithPlace:(int)PlaceVal andId:(int)IdVal andName:(NSString*)NameVal andScore:(int)ScoreVal andIsUser:(BOOL)IsUserVal;

@end
