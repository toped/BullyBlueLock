//
//  ViewPermissionsViewController.h
//  BullyBlueLock
//
//  Created by CTOstudent on 4/18/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPermissionsViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate> {
    
    IBOutlet UILabel *lockName;
    IBOutlet UILabel *cyclesLeft;
    IBOutlet UIScrollView *scrollView;
    
}
@end
