//
//  Photo.h
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocatableObject.h"

@interface Photo : LocatableObject {
    NSNumber *_photoId;
    NSNumber *_accountId;
    NSNumber *_points;    
    NSNumber *_timesFound;        
    NSString *_title;
    NSString *_description;
    NSString *_imageUrl;   
    NSString *_proximityDescription;
    NSString *_proximityColor;
    NSString *_submittedBy;
    NSString *_submittedByImageUrl;
    NSString *_submittedOn;
    NSString *_shotInformation;
    BOOL _found;
    BOOL _owner;    
}

+ (Photo *)photoFromJson:(NSDictionary *)photoJson;

@property(nonatomic, retain) NSNumber *photoId;
@property(nonatomic, retain) NSNumber *accountId;
@property(nonatomic, retain) NSNumber *points;
@property(nonatomic, retain) NSNumber *timesFound;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *proximityDescription;
@property(nonatomic, copy) NSString *proximityColor;
@property(nonatomic, copy) NSString *submittedBy;
@property(nonatomic, copy) NSString *submittedByImageUrl;
@property(nonatomic, copy) NSString *submittedOn;
@property(nonatomic, copy) NSString *shotInformation;
@property(nonatomic, assign) BOOL found;
@property(nonatomic, assign) BOOL owner;

@end