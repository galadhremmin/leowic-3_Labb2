//
//  AldBrickView.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AldBrick.h"

@interface AldBrickView : UIView

@property (nonatomic, weak) AldBrick *brick;

-(id) initWithBrick: (AldBrick *)brick;

@end
