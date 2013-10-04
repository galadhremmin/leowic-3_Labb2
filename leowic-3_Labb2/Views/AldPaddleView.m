//
//  AldPaddleView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/4/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageScaling.h"
#import "AldPaddleView.h"

@implementation AldPaddleView

-(id) initWithPaddle: (AldPaddle *)paddle
{
    self = [super initWithFrame:paddle.frame andBackground:@"paddle.jpg"];
    return self;
}

@end
