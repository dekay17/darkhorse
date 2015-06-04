//
//  ScoreboardData.m
//  Lavahound
//
//  Created by Russak Nathan on 3/13/12.
//  Copyright (c) 2012 LavaHound. All rights reserved.
//

#import "ScoreboardData.h"

@implementation ScoreboardData
@synthesize Place, Id, Name, Score, IsUser;

- (id) initWithPlace:(int)PlaceVal andId:(int)IdVal andName:(NSString*)NameVal andScore:(int)ScoreVal andIsUser:(BOOL)IsUserVal
{
    self = [super init];
    
    if (self)
    {
        Place   = PlaceVal;
        Id      = IdVal;
        Name    = [NameVal retain];
        Score   = ScoreVal;
        IsUser  = IsUserVal;
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [Name release];
}

@end
