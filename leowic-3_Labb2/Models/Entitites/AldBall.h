//
//  AldBall.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AldBallReflectPlane_t {
    kAldBallReflectNone = 0,
    kAldBallReflectLeft = 1,
    kAldBallReflectRight = 2,
    kAldBallReflectTop = 3,
    kAldBallReflectBottom = 4
} AldBallReflectPlane;

@interface AldBall : NSObject

@property(nonatomic) CGRect frame;
@property(nonatomic) CGFloat direction;
@property(nonatomic) CGFloat velocity;

-(id) initWithFrame: (CGRect)frame direction: (CGFloat)direction andVelocity: (CGFloat)velocity;
-(AldBallReflectPlane) moveWithinFrame: (CGRect)frame withinFractionsOfASecond:(CFTimeInterval)dt;
-(void) reflectAgainstSurfaceWithAngle: (CGFloat)angle;

@end
