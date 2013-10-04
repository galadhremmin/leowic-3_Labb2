//
//  AldBallView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/4/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldBallView.h"

@implementation AldBallView

-(id) initWithBall: (AldBall *)ball
{
    self = [super initWithFrame:ball.frame andBackground:@"planet.png"];
    if (self) {
        [self beginRotation];
    }
    return self;
}

-(void) beginRotation
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 3.0f;
    animation.repeatCount = HUGE_VAL;
    [self.layer addAnimation:animation forKey:@"RotationAnimation"];
}

@end
