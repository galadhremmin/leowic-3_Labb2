//
//  AldChoiceSelectionViewController.m
//  leowic-3_Labb2
//
//  Created by Leonard Wickmark on 10/1/13.
//  Copyright (c) 2013 LTU. All rights reserved.
//

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
    
    id choice = [_choices objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", choice]];
    cell.accessoryType = choice == _selectedChoice
        ? UITableViewCellAccessoryCheckmark
        : UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    _selectedChoice = [_choices objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
