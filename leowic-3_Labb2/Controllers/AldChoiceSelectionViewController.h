//
//  AldChoiceSelectionViewController.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AldChoiceSelectionViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, strong) id selectedChoice;

@end
