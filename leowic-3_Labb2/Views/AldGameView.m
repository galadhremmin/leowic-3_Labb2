//
//  AldGameView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldGameView.h"
#import "UIImageScaling.h"

@implementation AldGameView

-(void) awakeFromNib
{
    [self applyBackground];
}

-(void) applyBackground
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imagePath  = [resourcePath stringByAppendingPathComponent:@"background.jpg"];
    
    UIImage *backgroundNebula = [[UIImage imageWithContentsOfFile:imagePath] scaleToSize:self.frame.size];

    [self setBackgroundColor:[UIColor colorWithPatternImage:backgroundNebula]];
}

@end
