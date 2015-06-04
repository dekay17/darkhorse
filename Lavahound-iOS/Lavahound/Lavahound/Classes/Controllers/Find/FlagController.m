//
//  FlagController.m
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "FlagController.h"
#import "UIViewController+Lavahound.h"

static NSTimeInterval const kKeyboardAnimationDuration = 0.3;

@implementation FlagController

#pragma mark -
#pragma mark NSObject

- (id)initWithPhotoId:(NSNumber *)photoId {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _reasonTextView = nil;
        _photoId = [photoId retain];
        [self initializeLavahoundNavigationBarWithTitle:@"flag shot"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];           
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    _reasonTextView.delegate = nil;
    TT_RELEASE_SAFELY(_reasonTextView);
    TT_RELEASE_SAFELY(_photoId);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://flagImageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];     
    
    _reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 230, 290, 105)];
    _reasonTextView.delegate = self;    
    _reasonTextView.editable = YES;    
    _reasonTextView.returnKeyType = UIReturnKeyDone;
    _reasonTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_reasonTextView];
    
    UIImage *cancelButtonImage = TTIMAGE(@"bundle://buttonFlagImageCancel.png");
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	[cancelButton addTarget:self
                     action:@selector(didTouchUpInCancelButton)
           forControlEvents:UIControlEventTouchUpInside];
	cancelButton.frame = CGRectMake(18, 359, cancelButtonImage.size.width, cancelButtonImage.size.height);        
	[self.view addSubview:cancelButton]; 

    UIImage *flagButtonImage = TTIMAGE(@"bundle://buttonFlagImageFlag.png");
    UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[flagButton setImage:flagButtonImage forState:UIControlStateNormal];    
	[flagButton addTarget:self
                   action:@selector(didTouchUpInFlagButton)
         forControlEvents:UIControlEventTouchUpInside];
	flagButton.frame = CGRectMake(cancelButton.right + 6, cancelButton.top, flagButtonImage.size.width, flagButtonImage.size.height);
	[self.view addSubview:flagButton]; 
}

- (void)viewDidUnload {
    _reasonTextView.delegate = nil;
    [_reasonTextView removeFromSuperview];
    TT_RELEASE_SAFELY(_reasonTextView);
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark LavahoundFlagPhotoApiDelegate

- (void)lavahoundFlagPhotoApiDidFlagPhoto:(LavahoundFlagPhotoApi *)lavahoundFlagPhotoApi {
    //[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://flagged"] applyAnimated:YES]];
    TTAlert(@"Thanks, we've received your message. We'll review this photo as soon as we can.");
    [self dismissModalViewControllerAnimated:YES];      
}

#pragma mark -
#pragma mark FlagController

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = -152;
    [UIView commitAnimations]; 
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = 0;
    [UIView commitAnimations];    
}

- (void)didTouchUpInCancelButton {
    [_reasonTextView resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];  
}

- (void)didTouchUpInFlagButton {
    [_reasonTextView resignFirstResponder];    
    LavahoundFlagPhotoApi *lavahoundFlagPhotoApi = [[[LavahoundFlagPhotoApi alloc] init] autorelease];
    lavahoundFlagPhotoApi.delegate = self;
    [lavahoundFlagPhotoApi flagPhotoId:_photoId reason:_reasonTextView.text];
}

@end