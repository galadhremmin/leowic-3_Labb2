//
//  AldModel.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AldModelDelegate.h"

#define kDefaultNumberOfColumnsOfBricks (4)
#define kDefaultNumberOfRowsOfBricks    (6)
#define kDefaultGapInPercentage         (2)
#define kDefaultHeightInPercentage      (3)
#define kDefaultPaddleWidthInPercentage (20)

@interface AldModel : NSObject

@property (weak, nonatomic)   NSObject<AldModelDelegate> *delegate;

@property (nonatomic, strong) NSMutableArray             *bricks;
@property (nonatomic)         CGRect                      paddle;
@property (nonatomic)         int                         score;
@property (nonatomic)         CGRect                      bounds;

-(id)   initWithDelegate: (NSObject<AldModelDelegate> *)delegate;
-(void) loadWithBounds:   (CGRect)bounds;
-(void) save;

@end
