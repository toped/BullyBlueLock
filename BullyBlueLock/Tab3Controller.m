//
//  Tab3Controller.m
//  BullyBlueLock
//
//  Created by CTOstudent on 2/22/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "Tab3Controller.h"
#import "RegistrationViewController.h"
#import "GivePermissionViewController.h"
#import "RevokePermissionViewController.h"
#import "CheckLockUsageViewController.h"
#import "ViewPermissionsViewController.h"
#import "constants.h"
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface Tab3Controller ()

@end

@implementation Tab3Controller


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"gear32.png"];
        self.tabBarItem.title = @"Options";
        
        //set the title of the main view
        self.navigationItem.title = @"Options";
        
        ownerOptions = [NSArray arrayWithObjects:
                   @"Register a Blue Lock Account",
                   @"Give Permission",
                   @"Revoke Permission",
                   @"Change Backup Code",
                   @"Check Lock Usage",
                   nil];
        
        
        
        guestOptions = [NSArray arrayWithObjects:
                   @"View Permissions",
                   nil];
        
        otherOptions = [NSArray arrayWithObjects:
                        @"Delete Account",
                        nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set background based on device type
    UIColor *patternColor;
    patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall@2x.jpg"]];
    self.view.backgroundColor = patternColor;
    
    optionsArray = [[NSMutableArray alloc] init];
    
    NSDictionary *ownerOptionsDic = [NSDictionary dictionaryWithObject:ownerOptions forKey:@"data"];
    [optionsArray addObject:ownerOptionsDic];
    
    NSDictionary *guestOptionsDic = [NSDictionary dictionaryWithObject:guestOptions forKey:@"data"];
    [optionsArray addObject:guestOptionsDic];
    
    NSDictionary *otherOptionsDic = [NSDictionary dictionaryWithObject:otherOptions forKey:@"data"];
    [optionsArray addObject:otherOptionsDic];
    
    
    if (IS_OS_7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone; // this is a tweak to fix table view offset
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [optionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [optionsArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"   Owner Options";
    else if (section == 1)
        return @"   Guest Options";
    else
        return @" ";
        
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(0, 0, 320, 45);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.textColor = [UIColor grayColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.backgroundColor = [[UIColor alloc] initWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1.0];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    
    
    NSDictionary *dictionary = [optionsArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cellValue  isEqual: @"Delete Account"]) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
   
    
    cell.detailTextLabel.numberOfLines = 2;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [optionsArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
    
    NSLog(@"%@", selectedCell);
   
    if ([selectedCell  isEqual: @"Register a Blue Lock Account"]) {
        
        RegistrationViewController *targetController = [[RegistrationViewController alloc] init];
        [[self navigationController] pushViewController:targetController animated:YES];

    }
    if ([selectedCell  isEqual: @"Give Permission"]) {
        
        GivePermissionViewController *targetController = [[GivePermissionViewController alloc] init];
        [[self navigationController] pushViewController:targetController animated:YES];
        
    }
    if ([selectedCell  isEqual: @"Revoke Permission"]) {
        
        RevokePermissionViewController *targetController = [[RevokePermissionViewController alloc] init];
        [[self navigationController] pushViewController:targetController animated:YES];
        
    }
    if ([selectedCell  isEqual: @"Check Lock Usage"]) {
        
        CheckLockUsageViewController *targetController = [[CheckLockUsageViewController alloc] init];
        [[self navigationController] pushViewController:targetController animated:YES];
        
    }
    if ([selectedCell  isEqual: @"View Permissions"]) {
        
        ViewPermissionsViewController *targetController = [[ViewPermissionsViewController alloc] init];
        [[self navigationController] pushViewController:targetController animated:YES];
        
    }
    if ([selectedCell isEqualToString:@"Delete Account"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
        NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
        
        if(savedData == nil){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"You do not have a Blue Lock Account." delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
            [alert show];

        }
        else {
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uhhhh..." message:@"If you delete your Blue Lock Account, you will no longer have access to your Bully Blue Lock." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
            [alert setTag:03];
            [alert show];

        }
    }
    
    [optionsTable deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //If YES, i want to delete
    if ((alertView.tag == 03) && (buttonIndex != alertView.cancelButtonIndex)) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        if(![fileManager removeItemAtPath:userDataFilePath error:&error]){
            NSLog(@"error removing file");
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GoodBye" message:@"Your account has successfully been deleted." delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

@end
