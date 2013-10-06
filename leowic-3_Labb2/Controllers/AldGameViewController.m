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
#import "AldBallView.h"
#import "AldPaddleView.h"
#import "AldBrickView.h"
#import "AldScoreView.h"

@interface AldGameViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) AldModel      *model;
@property (nonatomic, weak)   UIView        *paddleView;
@property (nonatomic, weak)   UIView        *ballView;
@property (nonatomic)         CFTimeInterval lastRender;
@property (nonatomic)         float          touchBeginXCoordinate;
@end

@implementation AldGameViewController

-(void) awakeFromNib
{
    [super awakeFromNib];
}

-(void) viewDidLoad
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
}

-(void) viewDidAppear:(BOOL)animated
{
    if (_model.hasBeenModified || _model.state != kAldModelStateGameRunning) {
        [self clearView];
        [_model save];
        [_model reload];
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [_displayLink invalidate];
    _displayLink = nil;
    
    [_model save];
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Segue management
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settings"]) {
        id controller = [segue destinationViewController];
        [controller setModel:_model];
    }
}

#pragma mark Game loop
-(void) gameLoop
{
    CFTimeInterval now = [_displayLink timestamp];
    
    if (_lastRender == -1) {
        _lastRender = 0;
        // wait for two seconds to make sure that the player gets a chance to
        // familiarise herself with the board
        sleep(2);
        return;
    }
    
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
-(void) clearView
{
    // Remove all subviews from the current view
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void) startGame
{    
    [self clearView];
    
    // Now, create a view for every brick
    for (AldBrick *brick in _model.bricks) {
        AldBrickView *view = [[AldBrickView alloc] initWithBrick:brick];
        [self.view addSubview:view];
    }

    // Create the paddle view
    UIView *paddleView = [[AldPaddleView alloc] initWithPaddle:_model.paddle];
    [self.view addSubview:paddleView];
    _paddleView = paddleView;
    
    // Create the ball view
    AldBallView *ballView = [[AldBallView alloc] initWithBall:_model.ball];
    [self.view addSubview:ballView];
    _ballView = ballView;
    
    // Create score view
    CGRect scoreRect = CGRectMake(0, _model.bounds.size.height + _model.bounds.origin.y - 30, 30, 30);
    AldScoreView *scoreView = [[AldScoreView alloc] initWithFrame:scoreRect listeningToModel:_model];
    [self.view addSubview:scoreView];
    
    _lastRender = -1; // force the phone to wait for two seconds
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
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

-(void) modelLoadedWithModel: (id)model
{
    [self startGame];
}

-(void) modelReloadedWithModel: (id)model
{
    [self startGame];
}

-(void) modelWillSave: (id)model
{
    
}

-(void) modelStateChanged: (int)state
{
    if (_displayLink == nil) {
        return;
    }
    
    NSString *title, *message;
    switch (state) {
        case kAldModelStateGameFailed:
            title = @"Game over";
            message = [NSString stringWithFormat: @"Du lyckades samla ihop %d poäng.", _model.score];
            break;
        case kAldModelStateGameFinished:
            title = @"Bra jobb!";
            message = [NSString stringWithFormat: @"Du rensade alla block och samlade ihop hela %d poäng!", _model.score];
            break;
        default:
            return;
    }
    
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Starta om" otherButtonTitles:nil, nil];
    [view show];
}

#pragma mark UIAlertView delegates

-(void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (_displayLink == nil) {
        return;
    }
    
    [self clearView];
    [_model reload];
}


@end
