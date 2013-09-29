//
//  AldBrick.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AldBrick : NSObject

@property(nonatomic)           CGRect  frame;
@property(nonatomic)           BOOL    broken;
@property(nonatomic, readonly) int     ID;

-(id) initWithID: (int)ID andFrame: (CGRect)rect;

@end
