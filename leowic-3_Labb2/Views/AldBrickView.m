//
//  AldBrickView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldBrickView.h"

@implementation AldBrickView

-(id) initWithBrick: (AldBrick *)brick
{
    self = [super initWithFrame:brick.frame andBackground:@"rough.jpg"];
    if (self) {
        self.brick = brick;
        self.hidden = brick.broken;
    
        [brick addObserver:self forKeyPath:@"broken" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void) removeFromSuperview
{
    [_brick removeObserver:self forKeyPath:@"broken"];
    [super removeFromSuperview];
}

-(void) observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary *)change
                       context: (void *)context
{
    if ([keyPath isEqualToString:@"broken"]) {
        // Weak pointers because ARC automatically retains within blocks
        __weak AldBrick *brick = (AldBrick *)object;
        __weak UIView *animatedView = self;
        
        if (brick.broken) {
            [UIView animateWithDuration: 1.0
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveEaseIn
                             animations: ^{
                                 // Fade out the brick
                                 animatedView.alpha = 0;
                                 
                                 // Reduce the brick to nothing
                                 CGRect bounds = animatedView.bounds;
                                 bounds.size.width = 0;
                                 bounds.size.height = 0;
                                 
                                 [animatedView setBounds:bounds];
                             }
                             completion: ^(BOOL finished){
                                 // Now, when is completed, hide the view
                                 animatedView.hidden = YES;
                             }];
        }
    }
}

@end
