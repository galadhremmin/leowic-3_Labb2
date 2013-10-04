//
//  AldPaddleView.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/4/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AldPaddle.h"
#import "AldShadowedView.h"

@interface AldPaddleView : AldShadowedView

-(id) initWithPaddle: (AldPaddle *)paddle;

@end
