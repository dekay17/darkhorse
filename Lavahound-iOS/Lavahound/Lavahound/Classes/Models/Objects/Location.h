//
//  Location.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocatableObject.h"

typedef enum LocationType {
    LocationTypePlace,
    LocationTypePhoto
} LocationType;

@interface Location : LocatableObject {
    NSNumber *_locationId;
    NSString *_type;    
    NSString *_imageUrl;
    NSNumber *_huntCount;
    NSString *_placeName;
}

+ (Location *)locationFromJson:(NSDictionary *)locationJson;

@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, retain) NSNumber *locationId;
@property(nonatomic, retain) NSNumber *huntCount;
@property(nonatomic, copy) NSString *placeName;

@property(nonatomic, readonly) LocationType locationType;

@end