//
//  LavahoundStyleSheet.m
//  Lavahound
//
//  Created by Mark Allen on 5/21/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundStyleSheet.h"

@implementation LavahoundStyleSheet

// TODO: store off all other in-app colors, fonts, etc. in here so we can change in one spot.

// TTTableHeaderDragRefreshView

-(UIColor *) tableRefreshHeaderBackgroundColor { 
    return [UIColor clearColor];
} 

- (UIColor *)tableRefreshHeaderTextColor {
    return [UIColor grayColor ];
}

- (UIColor *)tableRefreshHeaderTextShadowColor {
    return [UIColor clearColor];
}

// Implement these as necessary

//- (UIFont *)tableRefreshHeaderLastUpdatedFont; 
//- (UIFont *)tableRefreshHeaderStatusFont; 
//- (UIColor *)tableRefreshHeaderTextShadowColor; 
//- (CGSize)tableRefreshHeaderTextShadowOffset; 
//- (UIImage *)tableRefreshHeaderArrowImage; 

@end