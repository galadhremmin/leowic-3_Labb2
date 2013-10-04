//
//  AldGameModelDelegate.h
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AldModelDelegate <NSObject>

-(void) modelLoadedWithModel: (id)model;
-(void) modelReloadedWithModel: (id)model;
-(void) modelWillSave: (id)model;
-(void) modelStateChanged: (int)state;

@end
