//
//  AldBrickView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldBrickView.h"

@implementation AldBrickView

-(id) initWithBrick: (AldBrick *)brick
{
    self = [super initWithFrame:brick.frame];
    if (self) {
        self.brick = brick;
        self.hidden = brick.broken;
        self.backgroundColor = [UIColor purpleColor];
        
        [brick addObserver:self forKeyPath:@"broken" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary *)change
                       context: (void *)context
{
    AldBrick *brick = (AldBrick *)object;
    
    if ([keyPath isEqualToString:@"broken"]) {
        self.hidden = brick.broken;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
