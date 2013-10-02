//
//  AldChoiceSelectionViewController.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

#import <math.h>
#import "AldChoiceSelectionViewController.h"

@interface AldChoiceSelectionViewController ()

@end

@implementation AldChoiceSelectionViewController

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
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Välj ett av nedanstående alternativ";
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [_choices count];
}

-(UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellChoice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id choice        = [_choices objectAtIndex:[indexPath row]];
    id currentChoice = [_model valueForKeyPath:_configurationPath];
    
    BOOL isEqual = NO;
    if ([choice isKindOfClass:[NSNumber class]]) {
        isEqual = ABS([choice floatValue] - [currentChoice floatValue]) < 0.0000001f;
    } else if ([choice isKindOfClass:[NSString class]]) {
        isEqual = [choice isEqualToString:currentChoice];
    } else {
        isEqual = (choice == currentChoice);
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", choice]];
    cell.accessoryType = isEqual
        ? UITableViewCellAccessoryCheckmark
        : UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    id choice = [_choices objectAtIndex:indexPath.row];
    
    [_model setValue:choice forKeyPath:_configurationPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
