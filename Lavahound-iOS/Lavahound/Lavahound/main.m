//
//  main.m
//  Lavahound
//
//  Created by Mark Allen on 4/27/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"LavahoundAppDelegate");
    [pool release];
    return retVal;
}