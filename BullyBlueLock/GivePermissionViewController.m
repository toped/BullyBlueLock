//
//  GivePermissionViewController.m
//  BullyBlueLock
//
//  Created by CTOstudent on 3/30/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "GivePermissionViewController.h"

@interface GivePermissionViewController ()

@end

@implementation GivePermissionViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view from its nib.
}

/*********************************************************************************
 * Function:       (void)dismissKeyboard
 * Input:          none
 * Output:         none
 * Overview:       This routine revokes control of the view from textfields
 *                 upon touch of the main view
 *
 * Notes:
 *********************************************************************************/
-(void)dismissKeyboard {
    // do the following for all textfields in your current view
    [guestName resignFirstResponder];
    [lockCycles resignFirstResponder];
    
    scrollView.contentSize = CGSizeMake(320, 480);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if([textField isEqual:lockCycles]) {
        scrollView.contentSize = CGSizeMake(320, 630);
    }
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
    
    if (userData == nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"You have not registerd a BlueLock account." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setTag:02];
        [alert show];
    }
    else{
        //To reterive the data from the plist
        NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
        
        
        //Send variable to let the lock know who it is
        if ([[savedData objectForKey:@"Name"]  isEqual: @"N/A"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"You do not own a BlueLock." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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

- ( IBAction )sendPermession:(id)sender{

    if([guestName.text length] == 0) {
        
    }
    else if([lockCycles.text length] == 0) {
        
    }
    else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
        
        NSMutableDictionary *guestUserData = [[NSMutableDictionary alloc] init];
        
        //To insert the data into the plist
        [guestUserData setObject:guestName.text forKey:@"GuestName"];
        [guestUserData setObject:lockCycles.text forKey:@"Lock Cycles"];
        [userData setObject:guestUserData forKey:@"Guest1"];
        [userData writeToFile: userDataFilePath atomically:YES];
        
        NSString *nameOfFile = [NSString stringWithFormat:@"%@%@", @"BL_", [userData objectForKey:@"Owner"]];
         nameOfFile = [NSString stringWithFormat:@"%@%@", nameOfFile, @".plist"]; //format should be .plist

        
        [ self postUpload : @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/register.php"
                          : userData
                          : nameOfFile];
        
        
        //edit the guestPlist
        NSString *url = [NSString stringWithFormat:@"%@%@", @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/", @"BL_"];
        url = [NSString stringWithFormat:@"%@%@", url, guestName.text];
        url = [NSString stringWithFormat:@"%@%@", url, @".plist"];
        
        NSMutableDictionary *guestPlist = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSMutableDictionary *guestPermissionData = [[NSMutableDictionary alloc] init];

        
        [guestPermissionData setObject:[userData objectForKey:@"Owner"] forKey:@"Owner"];
        [guestPermissionData setObject:[userData objectForKey:@"MasterUnlock"] forKey:@"MasterUnlock"];
        [guestPermissionData setObject:lockCycles.text forKey:@"Lock Cycles"];
        [guestPermissionData setObject:@"Not Accessed" forKey:@"Last Accessed"];
        [guestPlist setObject:guestPermissionData forKey:@"Shared"];
        
        
        NSString *guestFileName = [NSString stringWithFormat:@"%@%@", @"BL_", guestName.text];
        guestFileName = [NSString stringWithFormat:@"%@%@", guestFileName, @".plist"]; //format should be .plist
        
        
        [ self postUpload : @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/register.php"
                          : guestPlist
                          : guestFileName];
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Permission Sent"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];


    }
    
    
}

- ( BOOL )postUpload:( NSString *)url
                    :( NSMutableDictionary *)file
                    :( NSString *)filename
{
    
    NSMutableData *data = [ NSMutableData data ];
    NSData *uploadData = [NSPropertyListSerialization dataFromPropertyList:file format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    NSString *boundary = [ NSString stringWithFormat : @"---------------------------14737809831466499882746641449" ];
    
    
    [data appendData :[[ NSString stringWithFormat : @"\r\n--%@\r\n" ,boundary] dataUsingEncoding : NSUTF8StringEncoding ]];
    [data appendData :[[ NSString stringWithFormat : @"Content-Type: text/plist; boundary=%@\r\n" , boundary] dataUsingEncoding : NSUTF8StringEncoding ]];
    
    //content-disposition appended with new filename
    NSString *content = @"Content-Disposition: form-data; name=uploadfile; filename=";
    content = [NSString stringWithFormat:@"%@%@", content, filename];
    content = [NSString stringWithFormat:@"%@%@", content, @";\r\n"];
    
    [data appendData :[content dataUsingEncoding : NSUTF8StringEncoding ]];
    
    
    [data appendData :[[ NSString stringWithFormat : @"Content-Length: %lu\r\n\r\n" ,(unsigned long)[uploadData length ]] dataUsingEncoding : NSUTF8StringEncoding ]];
    [data appendData :[ NSData dataWithData :uploadData]];
    [data appendData :[[ NSString stringWithFormat : @"\r\n--%@--\r\n" ,boundary] dataUsingEncoding : NSUTF8StringEncoding ]];
    NSLog ( @"data: %lu, uploaddata: %lu" , (unsigned long)[data length], (unsigned long)[uploadData length ]);
    
    NSURL *theUrl = [ NSURL URLWithString :url];
    NSMutableURLRequest *urlRequest = [ NSMutableURLRequest requestWithURL :theUrl];
    [urlRequest setURL :theUrl];
    [urlRequest setHTTPMethod : @"POST" ];
    [urlRequest setHTTPBody :data];
    NSString *contentType = [ NSString stringWithFormat : @"multipart/form-data; boundary=%@" ,boundary];
    [urlRequest addValue :contentType forHTTPHeaderField : @"Content-Type" ];
    
    
    
    NSURLResponse *theResponse = NULL ;
    NSError *theError = NULL ;
    NSData *reqResults = [ NSURLConnection sendSynchronousRequest :urlRequest
                                                returningResponse :&theResponse
                                                            error :&theError];
    if (!reqResults) {
        NSLog ( @"Connection error for URL: %@" , [url description ]);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error in connection"
                              message:[theError localizedDescription ]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show ];
        
        return false;
    }
    else
    {
        return true;
    }
    NSLog ( @"reqResults: %@" , reqResults);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
