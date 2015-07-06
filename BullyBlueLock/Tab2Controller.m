//
//  Tab2Controller.m
//  BullyBlueLock
//
//  Created by CTOstudent on 2/22/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "constants.h"
#import "Tab2Controller.h"
#import <QuartzCore/QuartzCore.h>

@interface Tab2Controller ()

@end

@implementation Tab2Controller

@synthesize peripheral;
@synthesize state;
@synthesize bluetoothOn;
@synthesize helloCharacteristic, batteryCharacteristic, backupCharacteristic, testingCharacteristic, masterUnlockCharacteristic;

char rssiValue = -100;
BOOL bShowRSSI;
NSString *pName;
NSString *battery;
NSData *batteryLvl;
BOOL userIsRegistered = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"lock32.png"];
        self.tabBarItem.title = @"BlueLock";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//================================ LIFE CYCLE METHODS =====================================
- (void)viewWillAppear:(BOOL)animated
{
    //if(self.peripheral == nil){
    //    statusLabel.text = @"waiting....";
    //    welcomeLabel.text = @"No devices connected";
    //    rssiLabel.text = @"-dB";
    //}
    NSLog(@"refreshing");
    
    if (self.peripheral != nil)
    {
        [self disconnect];
        //[self search];
        //[self connect:self.peripheral];
    }

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:userDataFilePath];
    
    
    if (userData != nil){
        
        userIsRegistered = true;
        
        //To reterive the data from the plist
        NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
        
        
        
        if (![lockName  isEqual: @"N/A"]) {
            
            //User is an owner
            lockName = [savedData objectForKey:@"Name"];
            lockDiscript = [savedData objectForKey:@"Discription"];
            backupPasscode = [savedData objectForKey:@"Backup Passcode"];
            masterUnlockCode = [savedData objectForKey:@"MasterUnlock"];
            
            NSLog(@"The owner is:%@", userName);
            NSLog(@"The lock name is:%@", lockName);
            NSLog(@"The lock description is:%@", lockDiscript);
            NSLog(@"The backup passcode is:%@", backupPasscode);
            NSLog(@"The master passcode is:%@", masterUnlockCode);
            unlockButton.titleLabel.text = @"Unlock";
            cyclesLeft.hidden = YES;
        }
        
    }
    else {
        
        //if the lock is brand new, no one should be able to access it. i.e. passcode: 000000000 and UUID: any random, but unique, UUID
        userName = @"No Name";
        lockName = @"A Bully Blue Lock";
        lockDiscript = @"Not avaliable";
        backupPasscode = @"000000000";
        masterUnlockCode = @"14614D87-8B48-4CBF-8E76-CBE4D47E2B52"; //this is a random uuid that is not part of our GATT. Won't need this later, but i'm in a hurry
        unlockButton.titleLabel.text = @"not authorized";
        
    }
    
    userType.selectedSegmentIndex = 0;
    cyclesLeft.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDIsappear");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL supported;
    
    // Return YES for supported orientations
    // For simplicity, I want to support portrait mode for now
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            supported = YES;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            supported = NO;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            supported = NO;
            break;
        case UIInterfaceOrientationLandscapeRight:
            supported = NO;
            break;
        default:
            supported = NO;
            break;
    }
    return supported;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //set background based on device type
    UIColor *patternColor;
    patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall@2x.jpg"]];
    self.view.backgroundColor = patternColor;
    
    buttonBg.layer.cornerRadius = 15;
    buttonBg.layer.masksToBounds = YES;
    [buttonBg.layer setBorderColor: [[UIColor blackColor] CGColor]];
    //[buttonBg.layer setBorderWidth: 2.0];

    
    buttonLockBg.layer.cornerRadius = 15;
    buttonLockBg.layer.masksToBounds = YES;
    
    buttonUnlockBg.layer.cornerRadius = 15;
    buttonUnlockBg.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
    
    // not exactly necessary
    welcomeLabel = nil;
    rssiLabel = nil;
    connectionButton = nil;
    statusLabel = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



//================================ CENTRAL MANAGER DELEGATE METHODS =====================================
#pragma mark - CBCentralManager delegate methods

/*
 Invoked whenever the central manager's state is updated.
 */
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"BullyBlueLockViewController centralManagerDidUpdateState");
    
    self.bluetoothOn = NO;
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            self.state = @"Not Supported.";
            break;
        case CBCentralManagerStateUnauthorized:
            self.state = @"Not Authorized.";
            break;
        case CBCentralManagerStatePoweredOff:
            self.state = @"Powered Off.";
            break;
        case CBCentralManagerStatePoweredOn:
            self.state = @"Powered On.";
            self.bluetoothOn = YES;
            break;
        case CBCentralManagerStateUnknown:
        default:
            self.state = @"Unknown.";
    }
    
    NSLog(@"Central manager state: %@", self.state);
    
}

/*
 Invoked when the central discovers a peripheral while scanning.
 Note RSSI is the Received Signal Strength Indication
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"BullyBlueLockViewController didDiscoverPeripheral %@ advertisementData items: %lu", aPeripheral, (unsigned long)advertisementData.count);
    
    NSArray *keys = advertisementData.allKeys;
    NSArray *values = advertisementData.allValues;
    
    int i;
    for( i = 0; i < advertisementData.count; i++ )
    {
        NSLog(@"advertisementData %d: %@ %@", i, [keys objectAtIndex:i], [values objectAtIndex:i]);
    }
    
    //
    // There can be multiple didDiscoverPeripheral calls for the same peripheral as
    // advertisement data is discovered. As such, ensure there isn't already a
    // BluetoothDevice for this discovered peripheral.
    //
    
    
    //
    // If the adverstiment data has the local name, check to see if it is our magic Bully Blue Lock
    //
    NSString *localName = [advertisementData valueForKey:kCBAdvDataLocalName];
    if( localName != nil )
    {
        if([localName isEqualToString:ADV_DATA])
        {
            NSLog(@"Matched Blue Lock");
            
            //
            // We have the device we want, can stop scanning.
            //
            [manager stopScan];
            
            //
            // Found the demo device, save it and connect to the device.
            //
            self.peripheral = aPeripheral;
            [self connect:aPeripheral];
            
        }
    }
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"BullyBlueLockViewController didRetrievePeripheral");
}


/*
 Invoked whenever a connection is succesfully created with the peripheral.
 */
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"BullyBlueLockViewController didConnectPeripheral");
    [connectionButton setEnabled:YES];
    
    if( [self.peripheral.services count] == 0 )
    {
        //
        // Get the services
        //
        statusLabel.text = @"Finding Services";
        [aPeripheral discoverServices:nil];
    }
    bShowRSSI = YES;
    
    [[self peripheral] readRSSI];
    
}

/*
 Invoked whenever an existing connection with the peripheral is torn down.
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"BullyBlueLockViewController didDisconnectPeripheral");
    statusLabel.text = @"Disconnected";
    statusLabel.text = @"waiting....";
    welcomeLabel.text = @"No devices connected";
    rssiLabel.text = @"-dB";
    bShowRSSI = NO;
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"BullyBlueLockViewController Failed to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    statusLabel.text = @"Failed To Connect";
}

#pragma mark - CBPeripheral delegate methods

/*
 Invoked upon completion of a -[discoverServices:] request.
 Discover available characteristics on interested services
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aPeripheral.services)
    {
        NSLog(@"BullyBlueLockViewController Service found with UUID: %@", aService.UUID);
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:HELLOBLUETOOTH_SERVICE_UUID]])
            
        {
            NSLog(@"Found Service with 128 bit UUID");
            statusLabel.text = @"Finding Characteristics";
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
    }
}

/*
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 Perform appropriate operations on interested characteristics
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"BullyBlueLockViewController didDiscoverCharacteristicForService %@", service.UUID);
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:HELLOBLUETOOTH_SERVICE_UUID]])
        
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            //log all found characteristics
            NSLog(@"characteristic found %@", aChar.UUID);
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:HELLOBLUETOOTH_CHARACTERISTICS_NAME_UUID]])
            {
                NSLog(@"Characteristic found for the lock name");
                statusLabel.text = @"Reading Value for characteristic";
                [peripheral setNotifyValue:YES forCharacteristic:aChar];
                
                self.helloCharacteristic = aChar;
                [[self peripheral] readValueForCharacteristic:[self helloCharacteristic]];
                pName = [[NSString alloc] initWithUTF8String:[[helloCharacteristic value]bytes]];
                
                //[self updateLockName];
            }
            
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_BATTERY_CHARACTERISTICS_UUID]])
            {
                NSLog(@"My custom 128 bit characteristic found");
                statusLabel.text = @"Reading Value for characteristic";
                //[aPeripheral readValueForCharacteristic:aChar];
                
                [peripheral setNotifyValue:YES forCharacteristic:aChar];
                
                self.batteryCharacteristic = aChar;
                
            }
            
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_BACKUP_CHARACTERISTICS_UUID]])
            {
                NSLog(@"My custom 128 bit characteristic found");
                statusLabel.text = @"Reading Value for characteristic";
                //[aPeripheral readValueForCharacteristic:aChar];
                
                [peripheral setNotifyValue:YES forCharacteristic:aChar];
                
                self.backupCharacteristic = aChar;
                
                //[self sendBackupCode];
            }
            
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_TESTING_CHARACTERISTICS_UUID]])
            {
                NSLog(@"My custom 128 bit characteristic found");
                statusLabel.text = @"Reading Value for characteristic";
                //[aPeripheral readValueForCharacteristic:aChar];
                
                [peripheral setNotifyValue:YES forCharacteristic:aChar];
                
                self.testingCharacteristic = aChar;
                
            }
            
            /*
            
            Do a series of checks on the MasterUnlockCode
            
            */
            
            if (masterUnlockCode == NULL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You are not authorized to use this Blue Lock." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [self disconnect];
                
                return;
            }
            
            if(![aChar.UUID isEqual:[CBUUID UUIDWithString:HELLOBLUETOOTH_CHARACTERISTICS_NAME_UUID]] &&
               ![aChar.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_BATTERY_CHARACTERISTICS_UUID]] &&
               ![aChar.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_BACKUP_CHARACTERISTICS_UUID]] &&
               ![aChar.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_TESTING_CHARACTERISTICS_UUID]] &&
               ![aChar.UUID isEqual:[CBUUID UUIDWithString:@"e7731340-ea32-4127-be92-b77b34793bfa"]]){
                
                
                NSRegularExpression *regex;
                regex = [NSRegularExpression regularExpressionWithPattern:UUID_PATTERN
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:nil];
                int matches = [regex numberOfMatchesInString:masterUnlockCode options:0
                                                       range:NSMakeRange(0, [masterUnlockCode length])];
                
                if (matches == 1) {
                    
                    if ([aChar.UUID isEqual:[CBUUID UUIDWithString:masterUnlockCode]])
                    {
                        NSLog(@"My master unlock characteristic found");
                        statusLabel.text = @"Reading Value for characteristic";
                        //[aPeripheral readValueForCharacteristic:aChar];
                        
                        [peripheral setNotifyValue:YES forCharacteristic:aChar];
                        
                        self.masterUnlockCharacteristic = aChar;
                        
                    }
                    else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You are not authorized to use this Blue Lock." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        
                        [self disconnect];
                        
                        return;
                    }
                }
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please do not try to break into other people's Blue Lock." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    [self disconnect];
                    
                    return;
                }

            }
               
        }
    }
    
    if(userType.selectedSegmentIndex == 0){
       [self updateLockName];
       [self sendBackupCode];
    }
    statusLabel.text = @"Device Ready!";
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
        //[[self peripheral] readValueForCharacteristic:characteristic];
    }
    else {
        [[self peripheral] readValueForCharacteristic:characteristic];
    }
    
}


/***************************************************************************************************************************************************
 * Function:       peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
 * Input:          CBPeripheral, CBCharacteristic, NSError
 * Output:         none
 * Overview:
 *
 * Notes:          Invoked upon completion of a -[readValueForCharacteristic:] request or
 *                 on the reception of a notification/indication.
 ***************************************************************************************************************************************************/
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSLog(@"BullyBlueLockViewController didUpdateValueForCharacteristic %@", characteristic);
    
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:HELLOBLUETOOTH_CHARACTERISTICS_NAME_UUID]])
    {
        
        NSLog(@"Found name Characteristic: %@", [[NSString alloc] initWithUTF8String:[[characteristic value]bytes]]);
        pName = [[NSString alloc] initWithUTF8String:[[helloCharacteristic value]bytes]];
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_BATTERY_CHARACTERISTICS_UUID]])
    {
        
        NSLog(@"Found battery Characteristic: %@", [[NSString alloc] initWithUTF8String:[[characteristic value]bytes]]);
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_BACKUP_CHARACTERISTICS_UUID]])
    {
        
        NSLog(@"Found backup Characteristic: %@", [[NSString alloc] initWithUTF8String:[[characteristic value]bytes]]);
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLUELOCK_TESTING_CHARACTERISTICS_UUID]])
    {
        
         NSLog(@"Found testing Characteristic: %@", [[NSString alloc] initWithUTF8String:[[characteristic value]bytes]]);
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:masterUnlockCode]])
    {
        
        NSLog(@"Found master unlock code Characteristic: %@", [[NSString alloc] initWithUTF8String:[[characteristic value]bytes]]);
    }

}

/********************************************************************************************
 * Function:       peripheralDidUpdateRSSI:(CBPeripheral *)aPeripheral error:(NSError *)error
 * Input:          CBPeripheral, NSError
 * Output:         none
 * Overview:
 *
 * Notes:          Invoked when you retrieve the value of the peripheral’s
 *                 current RSSI while it is connected to the central manager.
 ********************************************************************************************/
- (void) peripheralDidUpdateRSSI:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    if(aPeripheral == nil)
        return;
    
    rssiValue = [aPeripheral.RSSI intValue];
    
    
    if(bShowRSSI == NO)
    {
        rssiLabel.text = @"----";
        welcomeLabel.text = @"No devices in range";
        return;
    }
    
    if([[self peripheral] isConnected] == YES)
    {
        rssiLabel.text = [NSString stringWithFormat:@"%d %@", rssiValue, @"dBm"];
        
        //This is for Trey. The RSSI is the recieved signal strength indicaiton.
        if(rssiValue > RSSI_THRESHOLD)
        {
            //NSString * pWelcome = [[NSString alloc] initWithFormat:@"Now connected to, %@", pName];
            NSString * pWelcome = pName;
            welcomeLabel.text = pWelcome;
            batteryLabel.text = battery;
        }
        else
            welcomeLabel.text = @"No devices in range";
        
        [[self peripheral] readRSSI];
    }
}


#pragma mark - UI Methods

/***************************************************************************
 * Function:       connectButtonPressed:(id)sender
 * Overview:       This routine performs a connect or disconnect action upon
 *                 button press based on the label of the button.
 *
 * Notes:          This is a debugging routine
 ***************************************************************************/
- (IBAction)connectButtonPressed:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    
    NSLog(@"connectionButtonPressed");
    if( [theButton.titleLabel.text isEqualToString:@"Disconnect"] )
    {
        [self disconnect];
    }
    else
    {
        [self connect:self.peripheral];
    }
}

#pragma mark - Utility Methods


- (void) search
{
    self.state = @"Scanning";
    [manager scanForPeripheralsWithServices:nil options:nil];
}

/***************************************************************************
 * Function:       (void) connect: (CBPeripheral *)aPeripheral
 * Input:          CBPeripheral
 * Output:         none
 * Overview:       This routine changes the label of our connection button
 *                 to Disconnect and establishes a connection to a
 *                 peripheral.
 *
 * Notes:          If self.peripheral does not exist, it simply returns
 *                 because there is nothing to connect to.
 ***************************************************************************/
- (void) connect: (CBPeripheral *)aPeripheral
{
    [connectionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    //
    // If there is an existing peripheral different from the new one, disconnect.
    //
    if( self.peripheral != nil && self.peripheral != aPeripheral)
    {
        [self disconnect];
    }
    
    self.peripheral = aPeripheral;
    
    //
    // If there isn't a new peripheral, no need to continue.
    //
    if( aPeripheral == nil )
    {
        return;
    }
    
    //
    // In the demo, we are a one-stop class. Be the peripheral delegate as well.
    //
    [aPeripheral setDelegate:self];
    
    //
    // If not already, connect to the device.
    //
    if( ![self.peripheral isConnected] )
    {
        [manager connectPeripheral:aPeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}






/***************************************************************************
 * Function:       (void) disconnect
 * Input:          none
 * Output:         none
 * Overview:       When the User presses the disconnect button, this routine
 *                 changes the label of our connection button the Connect
 *                 send also terminates the connection.
 *
 * Notes:
 ***************************************************************************/
- (void) disconnect
{
    
    buttonLockBg.backgroundColor = [UIColor darkGrayColor];
    buttonUnlockBg.backgroundColor = [UIColor clearColor];

    [connectionButton setTitle:@"Connect" forState:UIControlStateNormal];
    if( self.peripheral != nil)
    {
        if( [self.peripheral isConnected] )
        {
            [manager cancelPeripheralConnection:self.peripheral];
        }
    }
}




- (IBAction)startSearching:(id)sender{
    
    //
    // Setup Bluetooth support and start looking for devices.
    //
    if (userIsRegistered)
    {
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [connectionButton setEnabled:NO];
        statusLabel.text = @"Searching for Blue Lock Devices";
        [self search];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have not registered a Blue Lock account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}

/***************************************************************************
 * Function:       ( IBAction )sendToLock:(id)sender
 * Overview:        This routine is used to push data out to the GATT server
 *                  device.
 *
 * Notes:           This is a debugging routine
 ***************************************************************************/
- (void)updateLockName {
    
    
    /* Use this to send a string */
    NSString* str = lockName;
    if ([lockName length] <= 20) {
        NSInteger len = [lockName length];
        for (int i = 0; i <= (20 - len); i++) {
            str = [NSString stringWithFormat:@"%@%@", str, @" "];
        }
    }
    NSData *d = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [[self peripheral] writeValue:d forCharacteristic:[self helloCharacteristic]
                             type:CBCharacteristicWriteWithResponse];
    
    
    //readValueForCharacteristic to update value ForCharacteristic
    //[[self peripheral] readValueForCharacteristic:[self helloCharacteristic]];
    
    NSLog(@"The new lock name should be: %@", d);
    NSLog(@"The new lock name is indeed: %@", [helloCharacteristic value]);
    
}

/***************************************************************************
 * Function:       ( IBAction )sendBackupCode:(id)sender
 * Overview:        This routine is used to push data out to the GATT server
 *                  device.
 *
 * Notes:           This is a debugging routine
 ***************************************************************************/
- (void)sendBackupCode {
    
    const char *c = [backupPasscode UTF8String];
    
    unsigned char newArr[] = {c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8]};
    
    /* Use this to send a bit */
    unsigned char bytes[] = {(int)(newArr[0] - '0'),(int)(newArr[1] - '0'),(int)(newArr[2] - '0'),(int)(newArr[3] - '0'),(int)(newArr[4] - '0'),(int)(newArr[5] - '0'),(int)(newArr[6] - '0'),(int)(newArr[7] - '0'),(int)(newArr[8] - '0')};

    NSData *d = [[NSData alloc] initWithBytes:bytes length:9];
    
    [[self peripheral] writeValue:d forCharacteristic:[self backupCharacteristic]
                             type:CBCharacteristicWriteWithResponse];
    
    NSLog(@"The new backup code should be: %@", d);
    NSLog(@"The new backup code is indeed: %@", [backupCharacteristic value]);
    
    
}


/***************************************************************************
 * Function:       ( IBAction )sendBackupCode:(id)sender
 * Overview:        This routine is used to push data out to the GATT server
 *                  device.
 *
 * Notes:           This is a debugging routine
 ***************************************************************************/
- (IBAction)sendUnlockSignal:(id)sender{
    
    if (userIsRegistered) {
        
        if ([statusLabel.text  isEqual: @"Device Ready!"])
        {
            //if User is a guest
            if ([lockName  isEqual: @"N/A"]) {
            
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
            
                //Reterive data from the plist
                NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
            
                if (savedData != nil) {
                
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
                        
                        NSMutableDictionary *permissionInfo = [myPlist objectForKey:@"Shared"];
                        
                        NSString *cycles = [permissionInfo objectForKey:@"Lock Cycles"];
                        int cycleValue = cycles.intValue;
                        
                        if (cycleValue > 0) {
                            
                            buttonLockBg.backgroundColor = [UIColor clearColor];
                            buttonUnlockBg.backgroundColor = [UIColor darkGrayColor];
                            
                            /* Use this to send a bit */
                            unsigned char bytes[] = {0x01};
                            
                            NSData *d = [[NSData alloc] initWithBytes:bytes length:1];
                            
                            [[self peripheral] writeValue:d forCharacteristic:[self masterUnlockCharacteristic]
                                                     type:CBCharacteristicWriteWithResponse];
                            
                            NSLog(@"The new backup code should be: %@", d);
                            NSLog(@"The new backup code is indeed: %@", [masterUnlockCharacteristic value]);
                            
                            cycleValue--;
                            NSString *newCycleValue = [NSString stringWithFormat:@"%d",cycleValue];
                            
                            cyclesLeft.text = [NSString stringWithFormat:@"%@ %@", newCycleValue, @"lock cycle(s) left"];
                            
                            //get the date
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"MM/dd/yy"];
                            NSString *dateToday = [formatter stringFromDate:[NSDate date]];
                            
                            //get the time
                            [formatter setDateFormat:@"hh:mm:ss"];
                            NSString *timeNow = [formatter stringFromDate:[NSDate date]];
                            
                            NSString *lastAccessed = [NSString stringWithFormat:@"%@ %@", dateToday, timeNow];
                            
                            [permissionInfo setObject:newCycleValue forKey:@"Lock Cycles"];
                            [permissionInfo setObject:lastAccessed forKey:@"Last Accessed"];
                            
                            [myPlist setObject:permissionInfo forKey:@"Shared"];
                            
                            NSString *guestFileName = [NSString stringWithFormat:@"%@%@", @"BL_", [savedData objectForKey:@"Owner"]];
                            guestFileName = [NSString stringWithFormat:@"%@%@", guestFileName, @".plist"]; //format should be .plist
                            
                            
                            [ self postUpload : @"http://www.ece.msstate.edu/courses/design/2014/team_gary/scripts/register.php"
                                              : myPlist
                                              : guestFileName];

                        }// end cycle > 0 check
                        else{
                            if(cycles == nil){
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You permission has been revoked." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                [alert show];
                            }
                            else {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"sorry" message:@"You have used all of your lock cycles." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                [alert show];
                            }
                        }


                    }//end connection check
                    
                }//end saveddata != nil check
            }// end guest check
            else{
                
                buttonLockBg.backgroundColor = [UIColor clearColor];
                buttonUnlockBg.backgroundColor = [UIColor darkGrayColor];
                
                /* Use this to send a bit */
                unsigned char bytes[] = {0x01};
                
                NSData *d = [[NSData alloc] initWithBytes:bytes length:1];
                
                [[self peripheral] writeValue:d forCharacteristic:[self masterUnlockCharacteristic]
                                         type:CBCharacteristicWriteWithResponse];
                
                NSLog(@"The new backup code should be: %@", d);
                NSLog(@"The new backup code is indeed: %@", [masterUnlockCharacteristic value]);
                
                
            }


        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops.." message:@"No devices connected." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have not registered a Blue Lock account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}

/***************************************************************************
 * Function:       ( IBAction )refresh:(id)sender
 * Overview:        This routine is used to push data out to the GATT server
 *                  device.
 *
 * Notes:           This is a debugging routine
 ***************************************************************************/
- (IBAction)refresh:(id)sender{
    
    NSLog(@"refreshButtonPressed");
    
    if (self.peripheral != nil)
    {
        [self disconnect];
        [self search];
        //[self connect:self.peripheral];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops.." message:@"No devices connected." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(IBAction)changeData:(id)sender{
    
    
    switch (userType.selectedSegmentIndex) {
        case 0:
        {
            if (self.peripheral != nil)
            {
                [self disconnect];
                //[self search];
                //[self connect:self.peripheral];
            }
            cyclesLeft.hidden = YES;
            
            //User is an Owner
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
            
            //reterive data from the plist
            NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
            
            if (savedData != nil){
                
                if (![lockName  isEqual: @"N/A"]) {
                    
                    //User is an owner
                    lockName = [savedData objectForKey:@"Name"];
                    lockDiscript = [savedData objectForKey:@"Discription"];
                    backupPasscode = [savedData objectForKey:@"Backup Passcode"];
                    masterUnlockCode = [savedData objectForKey:@"MasterUnlock"];
                    
                    NSLog(@"The owner is:%@", userName);
                    NSLog(@"The lock name is:%@", lockName);
                    NSLog(@"The lock description is:%@", lockDiscript);
                    NSLog(@"The backup passcode is:%@", backupPasscode);
                    NSLog(@"The master passcode is:%@", masterUnlockCode);
                    unlockButton.titleLabel.text = @"Unlock";
                    unlockButton.enabled = YES;
                    
                }
                else{
                    
                    //userType.selectedSegmentIndex = 1;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You are not an owner of a Blue Lock" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                
            }
            
            break;
            
        }
        case 1:
        {
            if (self.peripheral != nil)
            {
                [self disconnect];
                //[self search];
                //[self connect:self.peripheral];
            }
            //User is a guest
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *userDataFilePath = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
            
            //Reterive data from the plist
            NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: userDataFilePath];
            
            if (savedData != nil) {
                
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
                    
                    NSMutableDictionary *permissionInfo = [myPlist objectForKey:@"Shared"];
                    
                    if (permissionInfo != nil) {
                    
                        masterUnlockCode = [permissionInfo objectForKey:@"MasterUnlock"];
                        
                        NSString *message = [NSString stringWithFormat:@"%@,%@", [permissionInfo objectForKey:@"Owner"], @" has given you permission to access their lock"];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        
                        cyclesLeft.hidden = NO;
                        cyclesLeft.text = [NSString stringWithFormat:@"%@ %@", [permissionInfo objectForKey:@"Lock Cycles"], @"lock cycle(s) left"];
                        
                    }
                    else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You have not been given permission to any Blue Locks" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    

                }
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have an interner connection to recieve your permission" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
            }
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You do not have not registered a Blue Lock account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }

            break;
            
        }
            
        default:
            break;
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

- (IBAction) help {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help" message:@"1. Make sure you have a registered accout. \n 2. Select whether you are an owner or a guest. \n 3. Tap the magnifying glass to search for your BlueLock. \n 4. When status updates to 'Device Ready!', tap the unlock button to unlock your BlueLock." delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
    [alert show];
}



@end
