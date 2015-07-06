//
//  Tab3Controller.h
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

@interface Tab3Controller : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate >
{
    //IBOutlet UIButton *updateName;
    IBOutlet UIButton *getRegistered;
    NSArray *ownerOptions;
    NSArray *guestOptions;
    NSArray *otherOptions;
    NSMutableArray *optionsArray;
    IBOutlet UITableView *optionsTable;
}

//- (IBAction)updateNamePressed:(id)sender;

@end
