//
//  AldGameViewController.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AldGameViewController.h"
#import "AldModel.h"
#import "AldBrickView.h"

@interface AldGameViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) AldModel      *model;
@property (nonatomic, weak)   UIView        *paddleView;
@property (nonatomic, weak)   UIView        *ballView;
@property (nonatomic)         CFTimeInterval lastRender;
@property (nonatomic)         float          touchBeginXCoordinate;
@end

@implementation AldGameViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Reduce the canvas with 2%
    int gap = self.view.bounds.size.width * 0.02;
    CGRect canvas = CGRectMake(
                               self.view.frame.origin.x + gap,
                               self.view.frame.origin.y + gap,
                               self.view.frame.size.width - 2*gap,
                               self.view.frame.size.height - gap -
                               [[UIApplication sharedApplication] statusBarFrame].size.height -
                               self.navigationController.navigationBar.frame.size.height);

    _model = [[AldModel alloc] initWithDelegate:self];
    [_model loadWithBounds:canvas];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_displayLink invalidate];
    _displayLink = nil;
    
    [_model save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Game loop
-(void) gameLoop
{
    CFTimeInterval now = [_displayLink timestamp];
    
    if (_lastRender == 0) {
        _lastRender = now;
        return;
    }

    CFTimeInterval dt = now - _lastRender;
    [_model update:dt];
    
    [_ballView setFrame:_model.ball.frame];
    [_paddleView setFrame:_model.paddle.frame];
    
    _lastRender = now;
}

#pragma mark View initialization
-(void) startGame
{
    // Remove all subviews from the current view
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Now, create a view for every brick
    for (AldBrick *brick in _model.bricks) {
        AldBrickView *view = [[AldBrickView alloc] initWithBrick:brick];
        [self.view addSubview:view];
    }

    // Create the paddle view
    UIView *paddleView = [[UIView alloc] initWithFrame:_model.paddle.frame];
    [paddleView setBackgroundColor: [UIColor redColor]];
    
    [self.view addSubview:paddleView];
    _paddleView = paddleView;
    
    // Create the ball view
    UIView *ballView = [[UIView alloc] initWithFrame:_model.ball.frame];
    [ballView setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:ballView];
    _ballView = ballView;
}

#pragma mark Touches

-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.view != _paddleView) {
        _touchBeginXCoordinate = -1;
    } else {
        _touchBeginXCoordinate = [touch locationInView:touch.view].x;
    }
}

-(void) touchesCancelled: (NSSet *)touches withEvent: (UIEvent *)event
{
    _touchBeginXCoordinate = -1;
}

-(void) touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{
    _touchBeginXCoordinate = -1;
}

-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    if (_touchBeginXCoordinate < 0) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGFloat x = [touch locationInView:self.view].x - _touchBeginXCoordinate;
    [_model.paddle moveWithinFrame:_model.bounds toNewXPosition:x];
}

#pragma mark Model delegates

-(void) modelInitializedWithModel: (id)model
{
}

-(void) modelLoadedWithModel: (id)model
{
    [self startGame];
}

-(void) modelReloadedWithModel: (id)model
{
    
}

-(void) modelWillSave: (id)model {
    
}

@end
