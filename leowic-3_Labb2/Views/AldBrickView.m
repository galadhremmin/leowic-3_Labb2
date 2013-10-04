//
//  AldBrickView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldBrickView.h"
#import "UIImageScaling.h"

@implementation AldBrickView

-(id) initWithBrick: (AldBrick *)brick
{
    self = [super initWithFrame:brick.frame];
    if (self) {
        self.brick = brick;
        self.hidden = brick.broken;
        
        [self applyBackground];
        [self applyShadow];
        [brick addObserver:self forKeyPath:@"broken" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void) removeFromSuperview
{
    [_brick removeObserver:self forKeyPath:@"broken"];
    [super removeFromSuperview];
}

-(void) applyBackground
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imagePath  = [resourcePath stringByAppendingPathComponent:@"rough.jpg"];
    
    UIImage *background = [[UIImage imageWithContentsOfFile:imagePath] scaleToSize:self.frame.size];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:background]];
}

-(void) applyShadow
{
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(3.f, 3.f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 2.f;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
