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

#define kDefaultNumberOfColumnsOfBricks  (4)
#define kDefaultNumberOfRowsOfBricks     (6)
#define kDefaultGapInPercentage          (2)
#define kDefaultHeightInPercentage       (3)
#define kDefaultPaddleWidthInPercentage  (20)
#define kDefaultBallDiameterInPercentage (5)
#define kDefaultBallVelocityInPercentage (30)
#define kDefaultBallDirectionInDegrees   (45)

@interface AldModel : NSObject

@property (weak, nonatomic)   NSObject<AldModelDelegate> *delegate;

@property (nonatomic, strong, readonly) NSMutableArray *bricks;
@property (nonatomic, strong, readonly) AldBall        *ball;
@property (nonatomic, readonly)         AldPaddle      *paddle;
@property (nonatomic, readonly)         CGRect          bounds;
@property (nonatomic, readonly)         int             score;
@property (nonatomic, readonly)         int             brickColumns;
@property (nonatomic, readonly)         int             brickRows;

-(id)   initWithDelegate: (NSObject<AldModelDelegate> *)delegate;
-(void) loadWithBounds:   (CGRect)bounds;
-(void) update:           (CFTimeInterval)dt;
-(void) save;

@end
