//
//  RegistrationViewController.m
//  BullyBlueLock
//
//  Created by CTOstudent on 2/27/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //set the title of the main view
        self.navigationItem.title = @"Registration";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *patternColor;
    patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall@2x.jpg"]];
    self.view.backgroundColor = patternColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    factory_uuid.text = @"C32CB835-CB53-4000-A942-C4817F42E21F";
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
    
    if (userData != nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"You have already registerd a BlueLock account." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setTag:02];
        [alert show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [lockName resignFirstResponder];
    [userName resignFirstResponder];
    [lockDiscript resignFirstResponder];
    [backupPasscode resignFirstResponder];
    [factory_uuid resignFirstResponder];
    
    scrollview.contentSize = CGSizeMake(320, 480);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if([textField isEqual:lockDiscript]) {
        scrollview.contentSize = CGSizeMake(320, 630);
    }
    
    return YES;
}



- ( IBAction )registerLockPressed:(id)sender
{

    if (registrationType.selectedSegmentIndex == 0) {
        
        NSInteger errorCode = [self validateUserInput];
        
        if (errorCode == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error?" message:@"Please enter a valid username." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
        else if (errorCode == 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error?" message:@"Please enter a valid lockname." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
        else if (errorCode == 3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error?" message:@"Please enter a valid description." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
        else if (errorCode == 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error?" message:@"Please enter a valid backup passcode." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
        else if (errorCode == 5) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error?" message:@"Please enter a valid UUID." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"If you are content with your changes, tap ok to register?" message:nil delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:@"Ok!", nil];
            [alert setTag:01];
            [alert show];
        }

    }
    else{
        if ([userName.text length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error?" message:@"Please enter a valid username." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"If you are content with your username, tap ok to register?" message:nil delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:@"Ok!", nil];
            [alert setTag:01];
            [alert show];
        }
    }
    
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //If YES, i want to upload
    if ((alertView.tag == 01) && (buttonIndex != alertView.cancelButtonIndex)) {
        
        
        //***********************
        //NSString *filePath1 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[@"customData" stringByAppendingString:@".plist"]];
        //NSMutableDictionary *plist1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath1];
        //NSMutableDictionary *bluelockdata = [plist1 objectForKey:@"Blue Lock Data"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
        
        if (userData != nil){
            userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
        }
        else {
            userData = [[NSMutableDictionary alloc] init];
        }

        //add elements to data file and write data to file
        NSString *newLockName = [lockName text];
        NSString *newUserName = [userName text];
        NSString *newLockDiscription = [lockDiscript text];
        NSString *newbackupCode = [backupPasscode text];
        //NSString *newuuid = [factory_uuid text];
        
        [userData setObject:newLockName forKey:@"Name"];
        [userData setObject:newUserName forKey:@"Owner"];
        [userData setObject:newLockDiscription forKey:@"Discription"];
        [userData setObject:newbackupCode forKey:@"Backup Passcode"];
        if (registrationType.selectedSegmentIndex == 0) {
            [userData setObject:[factory_uuid text] forKey:@"MasterUnlock"];
        }
        
        [userData writeToFile: userDataFilePath atomically:YES];
        
        
        //To reterive the data from the plist
        NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
        
        NSString *value1;
        value1 = [savedData objectForKey:@"Owner"];
        NSLog(@"The owner is:%@", value1);
        //************************
        
        
        // post now…
       
        
        //get the date today
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMddyy"];
        NSString *dateToday = [formatter stringFromDate:[NSDate date]];
        
        //get the time
        [formatter setDateFormat:@"hhmmss"];
        NSString *timeNow = [formatter stringFromDate:[NSDate date]];
        
        //NSString *nameOfFile = [NSString stringWithFormat:@"%@%@", @"BL_", [userName text]];
        //nameOfFile = [NSString stringWithFormat:@"%@_%@", nameOfFile, dateToday];
        //nameOfFile = [NSString stringWithFormat:@"%@_%@", nameOfFile, timeNow];
        //nameOfFile = [NSString stringWithFormat:@"%@%@", nameOfFile, @".plist"]; //format should be .plist
        
        NSString *nameOfFile = [NSString stringWithFormat:@"%@%@", @"BL_", [userName text]];
        nameOfFile = [NSString stringWithFormat:@"%@%@", nameOfFile, @".plist"]; //format should be .plist


        
        [ self postUpload : @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/register.php"
                          : userData
                          : nameOfFile];
        
        //FILE HAS BEEN SENT TO THE SERVER;
        //[self viewWillAppear:YES];
    }
    //If YES, i want to upload
    else if ((alertView.tag == 02) && (buttonIndex == alertView.cancelButtonIndex)) {
        
        [self.navigationController popToRootViewControllerAnimated:TRUE];
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
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Registration was Successful"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
          [alert show];

        return true;
    }
    NSLog ( @"reqResults: %@" , reqResults);
    
}

- (NSInteger) validateUserInput {
    
    if ([userName.text length] == 0) {
        return 1;
    }
    else if ([lockName.text length] == 0) {
        return 2;
    }
    else if ([lockDiscript.text length] == 0) {
        return 3;
    }
    else if ([backupPasscode.text length] != 9) {
        return 4;
    }
    //else if ([factory_uuid.text length] == 0) {
        //return 5;
    //}
    
    return 0;
}

-(IBAction)changeForm:(id)sender{
    
    
    switch (registrationType.selectedSegmentIndex) {
        case 0:
        {
            
            userName.enabled = YES;
            userName.text = @"";
            
            lockName.enabled = YES;
            lockName.backgroundColor = [UIColor whiteColor];
            lockName.text = @"";
            
            lockDiscript.enabled = YES;
            lockDiscript.backgroundColor = [UIColor whiteColor];
            lockDiscript.text = @"";
            
            backupPasscode.enabled = YES;
            backupPasscode.backgroundColor = [UIColor whiteColor];
            backupPasscode.text = @"";
            
            factory_uuid.enabled = YES; //this is the key to our security
            factory_uuid.backgroundColor = [UIColor whiteColor];
            factory_uuid.text = @"C32CB835-CB53-4000-A942-C4817F42E21F";
            
            break;

        }
        case 1:
        {
            UIColor *diabledColor = [UIColor colorWithRed:163/255.0f green:174/255.0f blue:178/255.0f alpha:1.0f];
            
            userName.enabled = YES;
            userName.text = @"";
            
            lockName.enabled = NO;
            lockName.backgroundColor = diabledColor;
            lockName.text = @"N/A";
            
            lockDiscript.enabled = NO;
            lockDiscript.backgroundColor = diabledColor;
            lockDiscript.text = @"N/A";
            
            backupPasscode.enabled = NO;
            backupPasscode.backgroundColor = diabledColor;
            backupPasscode.text = @"N/A";
            
            factory_uuid.enabled = NO; //this is the key to our security
            factory_uuid.backgroundColor = diabledColor;
            factory_uuid.text = @"N/A";
            
            break;

        }
            
        default:
            break;
    }

}


@end
