//
//  Points.h
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface Points : NSObject {
    NSNumber *_total;
    NSNumber *_finder;
    NSNumber *_hider;
    NSNumber *_royalties;
    NSString *_rank;    
    NSString *_rankPercentile;    
    NSString *_rankDescription;        
}

+ (Points *)pointsFromJson:(NSDictionary *)pointsJson;

@property(nonatomic, retain) NSNumber *total;
@property(nonatomic, retain) NSNumber *finder;
@property(nonatomic, retain) NSNumber *hider;
@property(nonatomic, retain) NSNumber *royalties;
@property(nonatomic, copy) NSString *rank;
@property(nonatomic, copy) NSString *rankPercentile;
@property(nonatomic, copy) NSString *rankDescription;

@end