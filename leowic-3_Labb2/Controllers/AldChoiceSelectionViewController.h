//
//  AldChoiceSelectionViewController.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AldModel.h"

@interface AldChoiceSelectionViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray  *choices;
@property (nonatomic, weak)   AldModel *model;
@property (nonatomic, strong) NSString *configurationPath;

@end
