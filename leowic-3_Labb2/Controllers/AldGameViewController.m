//
//  AldGameViewController.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 9/29/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldGameViewController.h"
#import "AldModel.h"
#import "AldBrickView.h"

@interface AldGameViewController ()
@property (nonatomic, strong) AldModel *model;
@property (nonatomic, weak) UIView *paddleView;
@property (nonatomic) float touchBeginXCoordinate;
@end

@implementation AldGameViewController

@synthesize model = _model;
@synthesize paddleView = _paddleView;
@synthesize touchBeginXCoordinate = _touchBeginXCoordinate;

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
                               self.view.frame.size.height - 2*gap -
                               [[UIApplication sharedApplication] statusBarFrame].size.height -
                               self.navigationController.navigationBar.frame.size.height);

    _model = [[AldModel alloc] initWithDelegate:self];
    [_model loadWithBounds:canvas];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    UIView *paddleView = [[UIView alloc] initWithFrame:_model.paddle];
    [paddleView setBackgroundColor: [UIColor redColor]];
    
    [self.view addSubview:paddleView];
    _paddleView = paddleView;
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
    
    if (x < _model.bounds.origin.x)
        x = _model.bounds.origin.x;
    
    if (x > _model.bounds.origin.x + _model.bounds.size.width - _paddleView.bounds.size.width)
        x = _model.bounds.origin.x + _model.bounds.size.width - _paddleView.bounds.size.width;
    
    CGRect frame = _paddleView.frame;
    frame.origin.x = x;
    
    [_paddleView setFrame:frame];
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
