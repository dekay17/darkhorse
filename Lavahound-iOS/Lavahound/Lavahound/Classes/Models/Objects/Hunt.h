//
//  Hunt.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocatableObject.h"

@interface Hunt : LocatableObject {
    NSNumber *_huntId;
    NSString *_name;
    NSString *_imageUrl;   
    NSString *_proximityDescription;
    NSNumber *_foundCount;
    NSNumber *_totalCount;    
}

+ (Hunt *)huntFromJson:(NSDictionary *)huntJson;

@property(nonatomic, retain) NSNumber *huntId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *proximityDescription;
@property(nonatomic, retain) NSNumber *foundCount;
@property(nonatomic, retain) NSNumber *totalCount;

@property(nonatomic, readonly) NSString *urlEncodedName;

@end