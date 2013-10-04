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

-(AldBallReflectPlane) moveWithinFrame: (CGRect)frame withinFractionsOfASecond:(CFTimeInterval)dt
{
    CGFloat dx = dt * cosf(_direction) * _velocity,
            dy = dt * sinf(_direction) * _velocity,
            x  = _frame.origin.x + dx,
            y  = _frame.origin.y + dy,
            angle = 0;
    
    AldBallReflectPlane reflect = kAldBallReflectNone;
    
    if (x <= frame.origin.x) {
        x = frame.origin.x;
        reflect = kAldBallReflectLeft;
        angle = M_PI/2;
    }
    
    if (y <= frame.origin.y) {
        y = frame.origin.y;
        reflect = kAldBallReflectTop;
        angle = M_PI;
    }
    
    if (x >= frame.size.width + frame.origin.x - _frame.size.width) {
        x = frame.size.width + frame.origin.x - _frame.size.width;
        reflect = kAldBallReflectRight;
        angle = M_PI/2;
    }
        
    if (y >= frame.size.height + frame.origin.y - _frame.size.height) {
        y = frame.size.height + frame.origin.y - _frame.size.height;
        reflect = kAldBallReflectBottom;
        angle = M_PI;
    }
    
    if (reflect != kAldBallReflectNone) {
        [self reflectAgainstSurfaceWithAngle:angle];
    }
    
    _frame.origin.x = x;
    _frame.origin.y = y;
    
    // It's tempting to use the observable pattern here and have the view listen to change
    // but performance disagrees with me!
    return reflect;
}

-(void) reflectAgainstSurfaceWithAngle: (CGFloat)angle
{
    CGFloat dir = 2 * angle - _direction;
    
    _direction = dir;
    while (_direction < -M_PI) {
        _direction += 2*M_PI;
    }
    
    while (_direction > M_PI) {
        _direction -= 2*M_PI;
    }
}

@end
