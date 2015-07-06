//
//  RevokePermissionViewController.m
//  BullyBlueLock
//
//  Created by CTOstudent on 4/10/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "RevokePermissionViewController.h"

@interface RevokePermissionViewController ()

@end

@implementation RevokePermissionViewController

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
            //First check for internet connection
            NSString *connectionCheck = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.ece.msstate.edu/"]
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:nil];
            //If guest has a connection
            if (connectionCheck != NULL) {
                NSString *url = [NSString stringWithFormat:@"%@%@", @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/", @"BL_"];
                url = [NSString stringWithFormat:@"%@%@", url, [savedData objectForKey:@"Owner"]];
                url = [NSString stringWithFormat:@"%@%@", url, @".plist"];
                
                NSMutableDictionary *myPlist = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                
                NSMutableDictionary *permissionInfo = [myPlist objectForKey:@"Guest1"];
                
                if (permissionInfo != nil) {
                    
                    guestName.text = [permissionInfo objectForKey:@"GuestName"];
                    
                    
                }
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats??" message:@"No one has permission to your lock" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                
                
            }
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have an internet connection to recieve your permission" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- ( IBAction )revokePermession:(id)sender{
    
    if([guestName.text length] == 0) {
        
    }
    else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
        
        //To remove the data from owner plist
        [userData removeObjectForKey:@"Guest1"];
        
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
        
       [guestPlist removeObjectForKey:@"Shared"];
        
        NSString *guestFileName = [NSString stringWithFormat:@"%@%@", @"BL_", guestName.text];
        guestFileName = [NSString stringWithFormat:@"%@%@", guestFileName, @".plist"]; //format should be .plist
        
        
        [ self postUpload : @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/register.php"
                          : guestPlist
                          : guestFileName];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Permission Revoked"
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



@end
