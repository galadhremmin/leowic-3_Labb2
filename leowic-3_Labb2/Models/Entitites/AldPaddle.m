//
//  AldPaddle.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldPaddle.h"

@implementation AldPaddle

-(id) initWithFrame: (CGRect)frame
{
    self = [super init];
    if (self) {
        _frame = frame;
    }
    return self;
}

-(void) moveWithinFrame: (CGRect)frame toNewXPosition: (CGFloat)x
{
    if (x < frame.origin.x)
        x = frame.origin.x;
    
    if (x > frame.origin.x + frame.size.width - _frame.size.width)
        x = frame.origin.x + frame.size.width - _frame.size.width;
    
    _frame.origin.x = x;
}

@end
