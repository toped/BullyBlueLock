//
//  ViewPermissionsViewController.m
//  BullyBlueLock
//
//  Created by CTOstudent on 4/18/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "ViewPermissionsViewController.h"

@interface ViewPermissionsViewController ()

@end

@implementation ViewPermissionsViewController

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
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    
    //Reterive data from the plist
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
    
    if (savedData != nil) {
        
        //First check for internet connection
        NSString *connectionCheck = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.ece.msstate.edu/"]
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
        //If user has a connection
        if (connectionCheck != NULL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/", @"BL_"];
            url = [NSString stringWithFormat:@"%@%@", url, [savedData objectForKey:@"Owner"]];
            url = [NSString stringWithFormat:@"%@%@", url, @".plist"];
            
            NSMutableDictionary *myPlist = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            NSMutableDictionary *permissionInfo = [myPlist objectForKey:@"Shared"];
            
            if (permissionInfo != nil) {
                
                lockName.text = [permissionInfo objectForKey:@"Owner"];
                cyclesLeft.text = [permissionInfo objectForKey:@"Lock Cycles"];
                
            }
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No permissions to display" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            
            
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have an internet connection to view your permissions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    } //end saved data check
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
