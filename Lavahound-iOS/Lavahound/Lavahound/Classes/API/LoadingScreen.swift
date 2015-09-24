//
//  LoadingScreen.swift
//  Lavahound
//
//  Created by Daniel Kelley on 9/17/15.
//  Copyright © 2015 LavaHound. All rights reserved.
//

import Foundation


class LoadingScreen {
    static let sharedInstance = LoadingScreen()
    
    var questionNumber = 0
    
    var loadingView: UIView;
    var loadingMessage: NSString;
    
    convenience override init() {
        self.init(fromString:"Please wait...") // calls above mentioned controller with default name
    }
    
    init(fromString string: NSString) {
        self.loadingMessage = string
        super.init()
    }
    
    func showLoadingSpinner(message:String){
        let applicationWindow:UIWindow! = UIApplication.].keyWindow;
        //
        loadingView = [[UIView ini  initWithFrame:applicationWindow.bounds];
            loadingView.alpha = 0;
            loadingView.backgroundColor = [UIColor blackColor];
            [applicationWindow addSubview:loadingView];
        //
        //            UIImage *messageViewBackgroundImage = [UIImage.
        //                TTIMAGE(@"bundle://loadingModalBG.png");
        //            _messageView = [[UIImageView alloc] initWithImage:messageViewBackgroundImage];
        //            _messageView.frame = CGRectMake(floorf((_overlayView.width - messageViewBackgroundImage.size.width) / 2),
        //                floorf((_overlayView.height - messageViewBackgroundImage.size.height) / 2),
        //                messageViewBackgroundImage.size.width,
        //                messageViewBackgroundImage.size.height);
        //            [applicationWindow addSubview:_messageView];
        //
        //            if(!message)
        //            message = @"Please wait...";
        //
        //            UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, floorf(_messageView.height - 74), _messageView.width, 44)] autorelease];
        //            activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //            activityIndicatorView.contentMode = UIViewContentModeCenter;
        //            [activityIndicatorView startAnimating];
        //            [_messageView addSubview:activityIndicatorView];
        //
        //            UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(14, 10, floorf(_messageView.width) - 28, activityIndicatorView.top - 20)] autorelease];
        //            messageLabel.lineBreakMode = UILineBreakModeWordWrap;
        //            messageLabel.numberOfLines = 0;
        //            messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        //            messageLabel.text = message;
        //            messageLabel.textColor = [UIColor whiteColor];
        //            messageLabel.textAlignment = UITextAlignmentCenter;
        //            messageLabel.contentMode = UIViewContentModeCenter;
        //            messageLabel.backgroundColor = [UIColor clearColor];
        //            [_messageView addSubview:messageLabel];
        //
        //            [UIView beginAnimations:nil context:NULL];
        //            [UIView setAnimationDuration:kFadeInAnimationDuration];    
        //            _overlayView.alpha = kOverlayAlpha;
        //            _messageView.alpha = 1;    
        //            [UIView commitAnimations]; 
        //        }
    }
    

    
}