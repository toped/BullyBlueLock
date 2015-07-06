//
//  RegistrationViewController.h
//  BullyBlueLock
//
//  Created by CTOstudent on 2/27/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "CoreBluetooth/CBUUID.h"
#import "CoreBluetooth/CBCentralManager.h"
#import "CoreBluetooth/CBPeripheral.h"
#import "CoreBluetooth/CBService.h"
#import "CoreBluetooth/CBCharacteristic.h"

#define kCBAdvDataLocalName @"kCBAdvDataLocalName"
#define kCBAdvDataServiceUUIDs @"kCBAdvDataServiceUUIDs"

@interface RegistrationViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate>
{
    //IBOutlet UIButton *updateName;
    IBOutlet UIButton *registerLock;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UISegmentedControl *registrationType;
    
    IBOutlet UITextField *userName;
    IBOutlet UITextField *lockName;
    IBOutlet UITextField *lockDiscript;
    IBOutlet UITextField *backupPasscode;
    IBOutlet UITextField *factory_uuid; //this is the key to our security
}


//- (IBAction)updateNamePressed:(id)sender;
- (IBAction)registerLockPressed:(id)sender;
- (IBAction)changeForm:(id)sender;

@end
