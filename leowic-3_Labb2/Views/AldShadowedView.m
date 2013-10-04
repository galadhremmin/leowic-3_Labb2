//
//  AldShadowedView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/4/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageScaling.h"
#import "AldShadowedView.h"

@implementation AldShadowedView

- (id)initWithFrame:(CGRect)frame andBackground: (NSString *)backgroundPath
{
    self = [super initWithFrame:frame];
    if (self) {
        [self applyBackground:backgroundPath];
        [self applyShadow];
    }
    return self;
}

-(void) applyBackground: (NSString *)backgroundPath
{
    if (backgroundPath == nil) {
        return;
    }
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imagePath  = [resourcePath stringByAppendingPathComponent:backgroundPath];
    
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
@end
