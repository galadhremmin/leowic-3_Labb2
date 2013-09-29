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

@synthesize defaults = _defaults;
@synthesize delegate = _delegate;
@synthesize bricks = _bricks;
@synthesize score = _score;
@synthesize paddle = _paddle;

-(id) initWithDelegate:(NSObject<AldModelDelegate> *)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _defaults = [NSUserDefaults standardUserDefaults];
        
        [delegate modelInitializedWithModel:self];
    }
    return self;
}

-(void) loadWithBounds: (CGRect)bounds
{
    self.bricks = [NSMutableArray array];
    self.bounds = bounds;
    
    int lastSave = [_defaults integerForKey:@"lastSave"];
    
    if (lastSave > 0) {
        // Load the previous game
        
    } else {
        int brickColumns = [self integerForKey:@"brickColumns" onZeroReturn:kDefaultNumberOfColumnsOfBricks];
        int brickRows = [self integerForKey:@"brickRows" onZeroReturn:kDefaultNumberOfRowsOfBricks];
        
        int gapSize = kDefaultGapInPercentage * 0.01 * bounds.size.width;
        int brickWidth = (bounds.size.width - (brickColumns - 1) * gapSize) / brickColumns;
        int brickHeight = kDefaultHeightInPercentage * 0.01 * bounds.size.height;
        
        for (int i = 1,
                 x = bounds.origin.x, y = bounds.origin.y;
             i <= brickColumns * brickRows;
             i += 1) {
            
            CGRect frame = CGRectMake(x, y, brickWidth, brickHeight);
            AldBrick *brick = [[AldBrick alloc] initWithID:i andFrame:frame];
            
            [_bricks addObject:brick];
            
            if (i % brickColumns == 0) {
                y += gapSize + brickHeight;
                x  = bounds.origin.x;
            } else {
                x += brickWidth + gapSize;
            }
        }
    }
    
    _paddle.size.width  = bounds.size.width * kDefaultPaddleWidthInPercentage * 0.01;
    _paddle.size.height = _paddle.size.width * 0.5;
    _paddle.origin.x    = (bounds.size.width - _paddle.size.width) * 0.5;
    _paddle.origin.y    = bounds.size.height - _paddle.size.height;

    [self.delegate modelLoadedWithModel:self];
}

-(void)  save
{
    [self.delegate modelWillSave:self];
    
    
    
    
}

- (int) integerForKey: (NSString *)key onZeroReturn: (int)onZeroValue
{
    int value = [_defaults integerForKey:key];
    
    if (value == 0) {
        return onZeroValue;
    }
    return value;
}

@end
