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
@property(nonatomic) int state;
@property(nonatomic) int score;

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
    
    [self setState: kAldModelStateGameInitializing];
    
    [self initBricksWithBounds: _bounds];
    [self initPaddleWithBounds: _bounds];
    [self initBallWithBounds:   _bounds];
    
    [self observeMutableConfiguration];
    
    [self.delegate modelLoadedWithModel:self];
    
    [self setState: kAldModelStateGameRunning];
}

-(void) reload
{
    // Change game state to initilaization
    [self setState: kAldModelStateGameInitializing];
    
    // Clear all observers
    [self unobserveMutableConfiguration];
    
    // Clear brick states
    NSDictionary *keys = [_defaults dictionaryRepresentation];
    for (NSString *key in keys) {
        if (key.length > 10 && [[key substringToIndex:10] isEqualToString:@"brickState"]) {
            [_defaults removeObjectForKey:key];
        }
    }
    
    // remove ball position
    [_defaults removeObjectForKey:@"ballX"];
    [_defaults removeObjectForKey:@"ballY"];
    
    // Initialize everything again
    [self initBricksWithBounds: _bounds];
    [self initPaddleWithBounds: _bounds];
    [self initBallWithBounds:   _bounds];
    
    [self observeMutableConfiguration];
    
    // Notify the delegate that the model has been reloaded
    [self.delegate modelReloadedWithModel:self];
    
    [self setState: kAldModelStateGameRunning];
}

-(void) update:(CFTimeInterval)dt
{
    if (_state != kAldModelStateGameRunning)
        return;
    
    AldBallReflectPlane reflected = [_ball moveWithinFrame:_bounds withinFractionsOfASecond:dt];
    
    if (reflected == kAldBallReflectBottom) {
        [self setState: kAldModelStateGameFailed];
        return;
    }
    
    if (reflected == kAldBallReflectNone) {
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
            [_ball reflectAgainstSurfaceWithAngle:M_PI];
            reflected = kAldBallReflectTop;
            
            break;
        }
    }
    
    // Paddle intersection
    if (reflected == kAldBallReflectNone && CGRectIntersectsRect(_ball.frame, _paddle.frame)) {
        CGRect intersection = CGRectIntersection(_ball.frame, _paddle.frame);
        [_ball reflectAgainstSurfaceWithAngle:M_PI];
    }
}

-(void) delete
{
    // Clear existing configuration
    NSDictionary *keys = [_defaults dictionaryRepresentation];
    for (id key in keys) {
        [_defaults removeObjectForKey:key];
    }
    _hasBeenModified = YES;
}

-(void) save
{
    [self.delegate modelWillSave:self];
    [self delete];
   
    // Save the bricks' state
    if (_state == kAldModelStateGameRunning) {
        for (AldBrick *brick in _bricks) {
            NSString *key = [NSString stringWithFormat:@"brickState%d", brick.ID];
            [_defaults setInteger:brick.broken ? 1 : 0 forKey:key];
        }
    }
    
    // Save the ball's position
    if (_state == kAldModelStateGameRunning) {
        [_defaults setFloat:_ball.frame.origin.x    forKey:@"ballX"];
        [_defaults setFloat:_ball.frame.origin.y    forKey:@"ballY"];
    }
    
    [_defaults setFloat:_ball.velocity          forKey:@"ballV"];
    [_defaults setFloat:_ball.direction         forKey:@"ballD"];
    
    // Save the number of bricks, columns and rows
    [_defaults setInteger:_brickColumns forKey:@"brickColumns"];
    [_defaults setInteger:_brickRows forKey:@"brickRows"];
    
    [_defaults setInteger:[NSDate timeIntervalSinceReferenceDate] forKey:@"lastSave"];
    [_defaults synchronize];
    
    _hasBeenModified = NO;
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
    
    // remove all existing bricks, as the game might be reloading
    [_bricks removeAllObjects];
    
    for (int i = 1, x = bounds.origin.x, y = bounds.origin.y;
         i <= _brickColumns * _brickRows;
         i += 1) {
        
        CGRect frame = CGRectMake(x, y, brickWidth, brickHeight);
        AldBrick *brick = [[AldBrick alloc] initWithID:i andFrame:frame];
        
        if (lastSave > 0) {
            // If there is a previous save-file, restore the brick's broken state
            NSString *key = [NSString stringWithFormat:@"brickState%d", i];
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
    srand(time(NULL));
    
    CGFloat defaultR = kDefaultBallDiameterInPercentage * bounds.size.width * 0.01 * 0.5,
            defaultV = kDefaultBallVelocityInPixels,
            defaultX = (bounds.size.width - defaultR*2) * 0.5,
            defaultY = (bounds.size.height - defaultR*2) * 0.5,
            defaultD = kDefaultBallDirectionInDegreesMin + (rand() % (kDefaultBallDirectionInDegreesMax - kDefaultBallDirectionInDegreesMin)) * M_PI / 180.0f,
            x, y, d, v;
    
    x = [self readFloatForKey:@"ballX" onZeroReturn:defaultX];
    y = [self readFloatForKey:@"ballY" onZeroReturn:defaultY];
    d = [self readFloatForKey:@"ballD" onZeroReturn:defaultD];
    v = [self readFloatForKey:@"ballV" onZeroReturn:defaultV];
    
    CGRect frame = CGRectMake(x, y, defaultR*2, defaultR*2);
    
    _ball = [[AldBall alloc] initWithFrame:frame direction:d andVelocity:v];
}

#pragma mark Mutable configuration observers

-(void) observeMutableConfiguration
{
    [self addObserver:self forKeyPath:@"ball.velocity" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"brickRows"     options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"brickColumns"  options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"state"         options:NSKeyValueObservingOptionNew context:nil];
    
    _hasBeenModified = NO;
}

-(void) unobserveMutableConfiguration
{
    [self removeObserver:self forKeyPath:@"ball.velocity"];
    [self removeObserver:self forKeyPath:@"brickRows"];
    [self removeObserver:self forKeyPath:@"brickColumns"];
    [self removeObserver:self forKeyPath:@"state"];
}

-(void) observeValueForKeyPath: (NSString *)keyPath ofObject: (id)object change: (NSDictionary *)change context: (void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        [_delegate modelStateChanged: _state];
        return;
    }
    
    _hasBeenModified = YES;
}

#pragma mark Score methods

-(void) award: (int)score
{
    [self setScore: score + _score];
    
    if (_score >= _bricks.count) {
        [self setState: kAldModelStateGameFinished];
    }
}

-(void) penalize: (int)score
{
    int newScore = _score - score;
    if (newScore < 0) {
        newScore = 0;
    }
    
    [self setScore:newScore];
}

#pragma mark Helper methods for persistance

-(int) readIntegerForKey: (NSString *)key onZeroReturn: (int)onZeroValue
{
    int value = [_defaults integerForKey:key];
    
    if (value == 0) {
        return onZeroValue;
    }
    return value;
}

-(CGFloat) readFloatForKey: (NSString *)key onZeroReturn: (CGFloat)onZeroValue
{
    int value = [_defaults floatForKey:key];
    
    if (value == 0) {
        return onZeroValue;
    }
    return value;
}

@end
