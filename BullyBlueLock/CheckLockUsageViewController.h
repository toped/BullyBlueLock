//
//  CheckLockUsageViewController.h
//  BullyBlueLock
//
//  Created by CTOstudent on 4/11/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckLockUsageViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate> {
    
    IBOutlet UILabel *guestName;
    IBOutlet UILabel *lastAccessX;
    IBOutlet UILabel *cyclesLeft;
    IBOutlet UIScrollView *scrollView;
    
}
@end
