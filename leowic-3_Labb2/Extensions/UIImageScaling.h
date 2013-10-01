//
//  UIImage.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Resize)
- (UIImage*)scaleToSize: (CGSize)size;
@end
