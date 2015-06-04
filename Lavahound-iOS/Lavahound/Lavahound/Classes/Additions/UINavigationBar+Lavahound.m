//
//  UINavigationBar+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UINavigationBar+Lavahound.h"

@implementation UINavigationBar(Lavahound)

- (void)drawRect:(CGRect)rect {
    [TTIMAGE(@"bundle://navigationBarBackground.png") drawInRect:self.bounds];
}

@end