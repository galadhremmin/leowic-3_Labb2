//
//  AldBrick.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldBrick.h"

@implementation AldBrick

@synthesize frame = _frame;
@synthesize broken = _broken;
@synthesize ID = _ID;

-(id) initWithID: (int)ID andFrame: (CGRect)frame
{
    self = [super init];
    if (self) {
        _frame = frame;
        _ID = ID;
        _broken = NO;
    }
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"AldBrick <%d> {x = %f, y = %f, width = %f, height = %f}",
            _ID, _frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height];
}

@end
