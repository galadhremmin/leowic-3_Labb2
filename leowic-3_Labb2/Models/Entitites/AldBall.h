//
//  AldBall.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldBall : NSObject

@property(nonatomic) CGRect frame;
@property(nonatomic) CGFloat direction;
@property(nonatomic) CGFloat velocity;

-(id) initWithFrame: (CGRect)frame direction: (CGFloat)direction andVelocity: (CGFloat)velocity;
-(BOOL) moveWithinFrame: (CGRect)frame withinFractionsOfASecond:(CFTimeInterval)dt;
-(void) reflect;

@end
