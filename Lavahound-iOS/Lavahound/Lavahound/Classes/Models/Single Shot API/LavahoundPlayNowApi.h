//
//  LavahoundPlayNowApi.h
//  Lavahound
//
//  Created by Mark Allen on 6/6/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundPlayNowApiDelegate;

@interface LavahoundPlayNowApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundPlayNowApiDelegate> _delegate;
}

- (void)playNow;

@property(nonatomic, assign) id<LavahoundPlayNowApiDelegate> delegate;

@end


@protocol LavahoundPlayNowApiDelegate<NSObject>

- (void)lavahoundPlayNowApiDidSignIn:(LavahoundPlayNowApi *)lavahoundPlayNowApi;

@end