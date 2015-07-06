//
//  GivePermissionViewController.h
//  BullyBlueLock
//
//  Created by CTOstudent on 3/30/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GivePermissionViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate> {
    
    IBOutlet UITextField *guestName;
    IBOutlet UITextField *lockCycles;
    IBOutlet UIScrollView *scrollView;
    
}

-(IBAction)sendPermession:(id)sender;

@end
