//
//  RevokePermissionViewController.h
//  BullyBlueLock
//
//  Created by CTOstudent on 4/10/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevokePermissionViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate> {
    
    IBOutlet UITextField *guestName;
    IBOutlet UIScrollView *scrollView;
    
}

-(IBAction)revokePermession:(id)sender;

@end
