//
//  AldBallView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/4/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldBallView.h"
#import "UIImageScaling.h"

@implementation AldBallView

-(id) initWithBall: (AldBall *)ball
{
    self = [super initWithFrame:ball.frame andBackground:@"planet.png"];
    return self;
}

@end
