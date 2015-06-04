//
//  ImagePicker.m
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ImagePicker.h"
#import "LocationTracker.h"
#import "LocalStorage.h"

@interface ImagePicker(PrivateMethods)

- (void)pickImageFromSourceType:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation ImagePicker

#pragma mark -
#pragma mark NSObject

- (id)initWithViewController:(UIViewController *)viewController delegate:(id<ImagePickerDelegate>)delegate {
    if((self = [super init])) {
        // Not retained!
        _viewController = viewController;
        _delegate = delegate;
    }
       
    return self;
}

- (void)dealloc {
    TTDPRINT(@"Deallocated.");
    [super dealloc];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
        [self pickImageFromSourceType:UIImagePickerControllerSourceTypeCamera];
    else if(buttonIndex == 1)
        [self pickImageFromSourceType:UIImagePickerControllerSourceTypePhotoLibrary];                
    else if(buttonIndex == 2)
        // Cancel
        [self autorelease];  
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSDictionary *)info {
    CLLocation *location = [LocationTracker sharedInstance].location;
    
    if(location) {
        TTDPRINT(@"Picked image. Location is %@", location);   
        
        // Write image to camera roll if taken on a camera
        if(imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];                
            UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
        }                                                                                         
        
        imagePickerController.delegate = nil;    
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];            
        [[LocalStorage sharedInstance] saveMostRecentlyPickedImage:pickedImage];        
        [_viewController dismissModalViewControllerAnimated:NO];
        [_delegate imagePicker:self didPickImage:pickedImage atLocation:location];
        [self autorelease];    
    } else {
        TTAlert(@"Sorry, looks like Location Services for Lavahound are disabled. You must enable them in your device's Settings application to upload photos.");        
        [self imagePickerControllerDidCancel:imagePickerController];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_viewController dismissModalViewControllerAnimated:YES];    
    picker.delegate = nil;    
    [self autorelease];
}

#pragma mark -
#pragma mark ImagePicker

- (void)showFromTabBar:(UITabBar *)tabBar {
    // We retain ourself for the duration of the "show" operation (from now until
    // the user cancels out the actionsheet or picks/cancels photo selection).
    // This way the onus is not on the calling code to know to hang on to a reference to us
    // until the actionsheet/imagepickercontroller finish.
    [self retain];
    
    // Prompt user if camera available, otherwise go straight to photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil] autorelease];
        [actionSheet showFromTabBar:tabBar];
    } else {
        [self pickImageFromSourceType:UIImagePickerControllerSourceTypePhotoLibrary];    
    }
}

- (void)pickImageFromSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
	imagePickerController.sourceType = sourceType;
	imagePickerController.allowsEditing = YES;
	imagePickerController.delegate = self;
    imagePickerController.navigationBar.tintColor = RGBCOLOR(173, 41, 0);
	[_viewController presentModalViewController:imagePickerController animated:YES];    
}

@end