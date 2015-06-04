//
//  Place.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocatableObject.h"

@interface Place : LocatableObject {
    NSNumber *_placeId;
    NSString *_name;
    NSString *_description;    
    NSString *_imageUrl;   
    NSString *_proximityDescription;
    NSNumber *_huntCount;
}

+ (Place *)placeFromJson:(NSDictionary *)placeJson;

@property(nonatomic, retain) NSNumber *placeId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *proximityDescription;
@property(nonatomic, retain) NSNumber *huntCount;

@end