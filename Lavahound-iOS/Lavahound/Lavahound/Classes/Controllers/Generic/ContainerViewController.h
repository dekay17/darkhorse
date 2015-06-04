//
//  ContainerViewController.h
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

// Special controller that contains subcontrollers and forwards messages along to them.
@interface ContainerViewController : TTViewController {
    NSMutableDictionary *_viewControllers;
}

@property(nonatomic, readonly) NSMutableDictionary *viewControllers;

@end