//
//  Tab2Controller.h
//  BullyBlueLock
//
//  Created by CTOstudent on 2/22/14.
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

@interface Tab2Controller : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *manager;
    
    IBOutlet UIButton *connectionButton;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UILabel *rssiLabel;
    IBOutlet UILabel *batteryLabel;
    NSString *masterUnlockCode;
    //debuging UI controls
    IBOutlet UIButton *unlockButton;
    IBOutlet UISegmentedControl *userType;
    
    //variables to send to lock upon connection
    NSString *userName;
    NSString *lockName;
    NSString *lockDiscript;
    NSString *backupPasscode;
    
    NSString *backupCode;
    IBOutlet UILabel *cyclesLeft;
    
    //astetics
    IBOutlet UIImageView *buttonBg;
    IBOutlet UIImageView *buttonLockBg;
    IBOutlet UIImageView *buttonUnlockBg;
}

@property (nonatomic, retain) CBPeripheral *peripheral;
@property (nonatomic, retain) CBCharacteristic *helloCharacteristic;
@property (nonatomic, retain) CBCharacteristic *batteryCharacteristic;
@property (nonatomic, retain) CBCharacteristic *backupCharacteristic;
@property (nonatomic, retain) CBCharacteristic *testingCharacteristic;
@property (nonatomic, retain) CBCharacteristic *masterUnlockCharacteristic;
@property (nonatomic, retain) NSString *state;
@property (nonatomic) BOOL bluetoothOn;


- (IBAction)startSearching:(id)sender;
- (IBAction)connectButtonPressed:(id)sender;
- (IBAction)sendUnlockSignal:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)changeData:(id)sender;

- (void)search;
- (void)connect:(CBPeripheral *)aPeripheral;
- (void)disconnect;

//debuging UI controls

@end

