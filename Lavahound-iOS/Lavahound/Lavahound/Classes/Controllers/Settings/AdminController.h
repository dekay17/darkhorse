//
//  AdminController.h
//  Lavahound
//
//  Created by Russak Nathan on 2/28/12.
//  Copyright (c) 2012 LavaHound. All rights reserved.
//

#import "UIViewController+Lavahound.h"
#import "Three20/Three20+Additions.h"
#import "ImagePicker.h"

@interface AdminController : TTViewController <ImagePickerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView * TheTable;
}

@end
