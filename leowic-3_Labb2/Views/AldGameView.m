//
//  AldGameView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldGameView.h"

@implementation AldGameView

-(void) awakeFromNib
{
    [self applyBackground];
}

-(void) applyBackground
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imagePath  = [resourcePath stringByAppendingPathComponent:@"background.jpg"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [self setImage:image];
    [self setContentMode:UIViewContentModeScaleAspectFill];
}

@end
