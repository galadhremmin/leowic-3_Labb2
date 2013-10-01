//
//  AldModel.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldModel.h"
#import "AldBrick.h"

@interface AldModel ()

@property(nonatomic, weak) NSUserDefaults *defaults;

@end

@implementation AldModel

-(id) initWithDelegate:(NSObject<AldModelDelegate> *)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void) loadWithBounds: (CGRect)bounds
{
    _bricks = [NSMutableArray array];
    _bounds = bounds;
    
    [self initBricksWithBounds: bounds];
    [self initPaddleWithBounds: bounds];
    [self initBallWithBounds:   bounds];
   
    [self.delegate modelLoadedWithModel:self];
}

-(void) update:(CFTimeInterval)dt
{
    BOOL reflected = [_ball moveWithinFrame:_bounds withinFractionsOfASecond:dt];
    
    if (!reflected) {
        // Check for intersections
        for (AldBrick *brick in _bricks) {
            // ignore broken bricks
            if (brick.broken) {
                continue;
            }
            
            if (!CGRectIntersectsRect(_ball.frame, brick.frame)) {
                continue;
            }
        
            [self award:1];
            [brick setBroken:YES];
            [_ball reflect];
            reflected = YES;
            
            break;
        }
    }
    
    // Paddle intersection
    if (!reflected && CGRectIntersectsRect(_ball.frame, _paddle.frame)) {
        CGRect intersection = CGRectIntersection(_ball.frame, _paddle.frame);
        
        NSLog(@"(%f, %f)", intersection.origin.x, intersection.origin.y);
        [_ball reflect];
    }
}

-(void) save
{
    [self.delegate modelWillSave:self];
    
    // Clear existing configuration
    NSDictionary *keys = [_defaults dictionaryRepresentation];
    for (id key in keys) {
        [_defaults removeObjectForKey:key];
    }
    
    // Save the bricks' state
    for (AldBrick *brick in _bricks) {
        NSString *key = [NSString stringWithFormat:@"brick%d", brick.ID];
        [_defaults setInteger:brick.broken ? 1 : 0 forKey:key];
    }
    
    // Save the ball's position
    [_defaults setFloat:_ball.frame.origin.x    forKey:@"ballX"];
    [_defaults setFloat:_ball.frame.origin.y    forKey:@"ballY"];
    [_defaults setFloat:_ball.velocity          forKey:@"ballV"];
    [_defaults setFloat:_ball.direction         forKey:@"ballD"];
    
    // Save the number of bricks, columns and rows
    [_defaults setInteger:_brickColumns forKey:@"brickColumns"];
    [_defaults setInteger:_brickRows forKey:@"brickRows"];
    
    [_defaults setInteger:[NSDate timeIntervalSinceReferenceDate] forKey:@"lastSave"];
    [_defaults synchronize];
}

#pragma mark Initialization methods
-(void) initBricksWithBounds: (CGRect)bounds
{
    // Read the number of columns and number of rows from the model. The size of
    // the bricks are thereafter calculated based on these values
    _brickColumns = [self readIntegerForKey:@"brickColumns" onZeroReturn:kDefaultNumberOfColumnsOfBricks];
    _brickRows = [self readIntegerForKey:@"brickRows" onZeroReturn:kDefaultNumberOfRowsOfBricks];
    
    // Timestamp when the configuration was last saved. 0 if this is the first time
    // the application is run.
    int lastSave    = [_defaults integerForKey:@"lastSave"],
    
    // The calculated size (horizontally and vertically) of the gap between the bricks
        gapSize     = kDefaultGapInPercentage * 0.01 * bounds.size.width,
    
    // Calculate the width and height of each brick, based on defaults and configuration
    // parameters
        brickWidth  = (bounds.size.width - (_brickColumns - 1) * gapSize) / _brickColumns,
        brickHeight = kDefaultHeightInPercentage * 0.01 * bounds.size.height;
    
    // Reset the score
    _score = 0;
    
    for (int i = 1, x = bounds.origin.x, y = bounds.origin.y;
         i <= _brickColumns * _brickRows;
         i += 1) {
        
        CGRect frame = CGRectMake(x, y, brickWidth, brickHeight);
        AldBrick *brick = [[AldBrick alloc] initWithID:i andFrame:frame];
        
        if (lastSave > 0) {
            // If there is a previous save-file, restore the brick's broken state
            NSString *key = [NSString stringWithFormat:@"brick%d", i];
            int state = [self readIntegerForKey:key onZeroReturn:0];
            [brick setBroken:state];
            
            if (brick.broken) {
                _score += 1;
            }
        }
        
        [_bricks addObject:brick];
        
        // Incremenet the x and y values according to the number of bricks per row
        if (i % _brickColumns == 0) {
            y += gapSize + brickHeight;
            x  = bounds.origin.x;
        } else {
            x += brickWidth + gapSize;
        }
    }
}

-(void) initPaddleWithBounds: (CGRect)bounds
{
    CGRect frame;
    
    frame.size.width  = bounds.size.width * kDefaultPaddleWidthInPercentage * 0.01;
    frame.size.height = frame.size.width * 0.5;
    frame.origin.x    = (bounds.size.width - frame.size.width) * 0.5;
    frame.origin.y    = bounds.size.height - frame.size.height;
    
    _paddle = [[AldPaddle alloc] initWithFrame:frame];
}

-(void) initBallWithBounds: (CGRect)bounds
{
    CGFloat defaultR = kDefaultBallDiameterInPercentage * bounds.size.width * 0.01 * 0.5,
            defaultV = kDefaultBallVelocityInPercentage * bounds.size.width * 0.01,
            defaultX = (bounds.size.width - defaultR*2) * 0.5,
            defaultY = (bounds.size.height - defaultR*2) * 0.5,
            defaultD = kDefaultBallDirectionInDegrees * M_PI / 180.0f,
            x, y, d, v;
    
    x = [self readFloatForKey:@"ballX" onZeroReturn:defaultX];
    y = [self readFloatForKey:@"ballY" onZeroReturn:defaultY];
    d = [self readFloatForKey:@"ballD" onZeroReturn:defaultD];
    v = [self readFloatForKey:@"ballV" onZeroReturn:defaultV];
    
    CGRect frame = CGRectMake(x, y, defaultR*2, defaultR*2);
    
    _ball = [[AldBall alloc] initWithFrame:frame direction:d andVelocity:v];
}

#pragma mark Score methods
-(void) award: (int)score
{
    _score += score;
}

-(void) penalize: (int)score
{
    _score -= score;
    if (_score < 0)
        _score = 0;
}

#pragma mark Helper methods for persistance

-(int) readIntegerForKey: (NSString *)key onZeroReturn: (int)onZeroValue
{
#if DEBUG
    return onZeroValue;
#endif
    
    int value = [_defaults integerForKey:key];
    
    if (value == 0) {
        return onZeroValue;
    }
    return value;
}

-(CGFloat) readFloatForKey: (NSString *)key onZeroReturn: (CGFloat)onZeroValue
{
#if DEBUG
    return onZeroValue;
#endif
    
    int value = [_defaults floatForKey:key];
    
    if (value == 0) {
        return onZeroValue;
    }
    return value;
}

@end
