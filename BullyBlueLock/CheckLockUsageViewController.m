//
//  CheckLockUsageViewController.m
//  BullyBlueLock
//
//  Created by CTOstudent on 4/11/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "CheckLockUsageViewController.h"

@interface CheckLockUsageViewController ()

@end

@implementation CheckLockUsageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //User must be an owner
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    
    //Reterive data from the plist
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
    
    if (savedData != nil) {
        
        if (![[savedData objectForKey:@"Name"]  isEqual: @"N/A"]) {
            
            NSMutableDictionary *guestInfo = [savedData objectForKey:@"Guest1"];
            //First check for internet connection
            NSString *connectionCheck = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.ece.msstate.edu/"]
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:nil];
            //If user has a connection
            if (connectionCheck != NULL) {
                NSString *url = [NSString stringWithFormat:@"%@%@", @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/", @"BL_"];
                url = [NSString stringWithFormat:@"%@%@", url, [guestInfo objectForKey:@"GuestName"]];
                url = [NSString stringWithFormat:@"%@%@", url, @".plist"];
                
                NSMutableDictionary *myPlist = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                
                NSMutableDictionary *permissionInfo = [myPlist objectForKey:@"Shared"];
                
                if (permissionInfo != nil) {
                    
                    guestName.text = [myPlist objectForKey:@"Owner"];
                    cyclesLeft.text = [permissionInfo objectForKey:@"Lock Cycles"];
                    lastAccessX.text = [permissionInfo objectForKey:@"Last Accessed"];
                    
                }
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No usage to display" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                
                
            }
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have an internet connection to view lock usage" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You are not an owner of a Blue Lock account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:02];
            [alert show];
            
        }
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ((alertView.tag == 02) && (buttonIndex == alertView.cancelButtonIndex)) {
        
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
