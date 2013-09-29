//
//  AldBall.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldBall.h"

@implementation AldBall

-(id) initWithFrame: (CGRect)frame direction: (CGFloat)direction andVelocity: (CGFloat)velocity
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.direction = direction;
        self.velocity = velocity;
    }
    return self;
}

-(BOOL) moveWithinFrame: (CGRect)frame withinFractionsOfASecond:(CFTimeInterval)dt
{
    CGFloat dx = dt * cosf(_direction) * _velocity,
            dy = dt * -sinf(_direction) * _velocity,
            x  = _frame.origin.x + dx,
            y  = _frame.origin.y + dy;
    
    BOOL reflect = NO;
    
    if (x <= frame.origin.x) {
        x = frame.origin.x;
        reflect = YES;
    }
    
    if (y <= frame.origin.y) {
        y = frame.origin.y;
        reflect = YES;
    }
    
    if (x >= frame.size.width + frame.origin.x - _frame.size.width) {
        x = frame.size.width + frame.origin.x - _frame.size.width;
        reflect = YES;
    }
        
    if (y >= frame.size.height + frame.origin.y - _frame.size.height) {
        y = frame.size.height + frame.origin.y - _frame.size.height;
        reflect = YES;
    }
    
    if (reflect) {
        [self reflect];
    }
    
    _frame.origin.x = x;
    _frame.origin.y = y;
    
    // It's tempting to use the observable pattern here and have the view listen to change
    // but performance disagrees with me!
    return reflect;
}

-(void) reflect
{
    _direction += M_PI * 0.5f;
    
    while (_direction >= 2*M_PI) {
        _direction -= 2*M_PI;
    }
}

@end
