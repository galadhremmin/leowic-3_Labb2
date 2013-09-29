//
//  AldPaddle.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldPaddle : NSObject

@property(nonatomic) CGRect frame;

-(id) initWithFrame: (CGRect)frame;
-(void) moveWithinFrame: (CGRect)frame toNewXPosition: (CGFloat)x;

@end
