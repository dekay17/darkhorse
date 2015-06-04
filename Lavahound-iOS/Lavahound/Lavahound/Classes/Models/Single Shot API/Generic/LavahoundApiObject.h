//
//  LavahoundApiObject.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApi.h"

@interface LavahoundApiObject : NSObject<LavahoundApiDataSource, LavahoundApiDelegate> {
    LavahoundApi *_lavahoundApi;
}

- (id)initWithOverlayEnabled:(BOOL)overlayEnabled;

@end