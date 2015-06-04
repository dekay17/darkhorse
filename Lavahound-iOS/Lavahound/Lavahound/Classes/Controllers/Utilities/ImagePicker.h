//
//  ImagePicker.h
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import <CoreLocation/CoreLocation.h>

@protocol ImagePickerDelegate;

@interface ImagePicker : NSObject<UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate> {
    // Not retained!
    UIViewController *_viewController;
    id<ImagePickerDelegate> _delegate;
}

+ (UIButton *)standardCameraButton;

- (id)initWithViewController:(UIViewController *)viewController delegate:(id<ImagePickerDelegate>)delegate;
- (void)show;

@end

@protocol ImagePickerDelegate

- (void)imagePicker:(ImagePicker *)imagePicker didPickImage:(UIImage *)image atLocation:(CLLocation *)location;

@end