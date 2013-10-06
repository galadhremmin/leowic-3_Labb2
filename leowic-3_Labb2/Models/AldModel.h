//
//  AldModel.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AldModelDelegate.h"
#import "AldBall.h"
#import "AldPaddle.h"

#define kDefaultNumberOfColumnsOfBricks   (4)
#define kDefaultNumberOfRowsOfBricks      (6)
#define kDefaultGapInPercentage           (2)
#define kDefaultHeightInPercentage        (3)
#define kDefaultPaddleWidthInPercentage   (20)
#define kDefaultBallDiameterInPercentage  (5)
#define kDefaultBallVelocityInPixels      (100)
#define kDefaultBallDirectionInDegreesMax (135)
#define kDefaultBallDirectionInDegreesMin (45)

#define kAldModelStateGameInitializing    (0)
#define kAldModelStateGameRunning         (1)
#define kAldModelStateGameFinished        (2)
#define kAldModelStateGameFailed          (3)

@interface AldModel : NSObject

@property (weak, nonatomic)   NSObject<AldModelDelegate> *delegate;

@property (nonatomic, strong, readonly) NSMutableArray *bricks;
@property (nonatomic, strong)           AldBall        *ball;
@property (nonatomic, readonly)         AldPaddle      *paddle;
@property (nonatomic, readonly)         CGRect          bounds;
@property (nonatomic, readonly)         int             state;
@property (nonatomic, readonly)         int             score;
@property (nonatomic)                   int             brickColumns;
@property (nonatomic)                   int             brickRows;
@property (nonatomic, readonly)         BOOL            hasBeenModified;

-(id)   initWithDelegate: (NSObject<AldModelDelegate> *)delegate;
-(void) loadWithBounds:   (CGRect)bounds;
-(void) reload;
-(void) update:           (CFTimeInterval)dt;
-(void) delete;
-(void) save;

@end
