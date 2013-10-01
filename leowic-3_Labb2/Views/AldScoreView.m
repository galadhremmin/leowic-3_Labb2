//
//  AldScoreView.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldScoreView.h"

@implementation AldScoreView

- (id)initWithFrame:(CGRect)frame listeningToModel: (AldModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setText:@"0"];
        [self setTextColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        [model addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary *)change
                       context: (void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        [self setText:[NSString stringWithFormat:@"%d", [object score]]];
    }
}

@end
