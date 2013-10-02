//
//  AldSettingsViewController.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import "AldSettingsViewController.h"
#import "AldChoiceSelectionViewController.h"

@interface AldSettingsViewController ()

@end

@implementation AldSettingsViewController

-(id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear: (BOOL)animated
{
    if (_model.hasBeenModified) {
        UITableView *view = (UITableView *)self.view;
        [view reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 2;
    }
    
    return 0;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Inställningar";
        case 1:
            return @"Nuvarande spel";
        default:
            return nil;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *label      = nil;
    NSString *valueLabel = nil;
    
    int identifier = indexPath.row + indexPath.section * 10;
    switch (identifier) {
        case 0:
            label      = @"Rader";
            valueLabel = [NSString stringWithFormat:@"%d", [_model brickRows]];
            break;
        case 1:
            label      = @"Block per rad";
            valueLabel = [NSString stringWithFormat:@"%d", [_model brickColumns]];
            break;
        case 2:
            label      = @"Hastighet";
            valueLabel = [NSString stringWithFormat:@"%.2f", _model.ball.velocity];
            break;
        case 10:
            label = @"Återställ";
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 11:
            label = @"Återgå";
            break;
        default:
            NSLog(@"Unrecognised menu item %d", identifier);
            return nil;
    }
    
    [cell.textLabel setText:label];
    [cell.detailTextLabel setText:valueLabel];
    
    return cell;
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int identifier = indexPath.row + indexPath.section * 10;
    NSArray  *choices = nil;
    NSString *key;
    
    switch (identifier) {
        case 0:
            choices = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], nil];
            key = @"brickRows";
            break;
        case 1:
            choices = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], nil];
            key = @"brickColumns";
            break;
        case 2:
            choices = [NSArray arrayWithObjects:[NSNumber numberWithFloat:40.f], [NSNumber numberWithFloat:50.f], [NSNumber numberWithFloat:80.f], [NSNumber numberWithFloat:100.f], [NSNumber numberWithFloat:130.f], [NSNumber numberWithFloat:200.f], [NSNumber numberWithFloat:300.f], nil];
            key = @"ball.velocity";
            break;
        case 10:
            [_model delete];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case 11:
            [self dismissViewControllerAnimated:true completion:nil];
            break;
    }
    
    if (choices != nil) {
        id choicesController = [[AldChoiceSelectionViewController alloc] init];
        [choicesController setChoices:choices];
        [choicesController setModel:_model];
        [choicesController setConfigurationPath:key];
        
        [self presentViewController:choicesController animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
