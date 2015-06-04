//
//  MyPointsController.h
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "ModelViewController.h"

@interface MyPointsController : ModelViewController {
    UILabel *_totalLabel;    
    UILabel *_finderLabel;    
    UILabel *_hiderLabel;
    UILabel *_royaltiesLabel;    
    UILabel *_rankPercentileLabel;
    UILabel *_rankDescriptionLabel;    

    UILabel *_totalPointsLabel;    
    UILabel *_finderPointsLabel;    
    UILabel *_hiderPointsLabel;
    UILabel *_royaltiesPointsLabel;    
    
}

@end