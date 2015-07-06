//
//  constants.h
//  BullyBlueLock
//
//  Created by CTOstudent on 2/22/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#ifndef BullyBlueLock_constants_h
#define BullyBlueLock_constants_h


//#define HELLOBLUETOOTH_SERVICE_UUID                         @"5AB20001-B355-4D8A-96EF-2963812DD0B8"
//#define HELLOBLUETOOTH_CHARACTERISTICS_NAME_UUID            @"5AB20002-B355-4D8A-96EF-2963812DD0B8"

#define HELLOBLUETOOTH_SERVICE_UUID                          @"384abbc5-9ad6-4eaa-86af-1ee629ba9838"

#define HELLOBLUETOOTH_CHARACTERISTICS_NAME_UUID             @"ee7c328f-6d47-4935-96ae-7ab28942074c"
#define BLUELOCK_BATTERY_CHARACTERISTICS_UUID                @"f1b41cde-dbf5-4acf-8679-ecb8b4dca6fe"
#define BLUELOCK_BACKUP_CHARACTERISTICS_UUID                 @"0bd51666-e7cb-469b-8e4d-2742f1ba77cc"
#define BLUELOCK_TESTING_CHARACTERISTICS_UUID                @"86326989-7691-481B-99D2-F185444CBACC"
#define BLUELOCK_BOND_TRIGGER_CHARACTERISTICS_UUID           @"7EEE62F6-C07A-481F-A963-49CBDAEE15D5"
#define UUID_PATTERN                                         @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"


// If the adverstiment data has the local name, check to see if it is our magic BlueLock.
#define ADV_DATA                                             @"BullyBlueLock"

//RSSI Threshold Low in dBm
#define RSSI_THRESHOLD                                      -100

//These defines are not used in our code, and they all may or may not be correct
#define TI_BlueLock_PROXIMITY_ALERT_ON_VAL                    0x01
#define TI_BlueLock_PROXIMITY_ALERT_OFF_VAL                   0x00
#define TI_BlueLock_PROXIMITY_ALERT_WRITE_LEN                 1
#define TI_BlueLock_PROXIMITY_TX_PWR_SERVICE_UUID             0x1804
#define TI_BlueLock_PROXIMITY_TX_PWR_NOTIFICATION_UUID        0x2A07
#define TI_BlueLock_PROXIMITY_TX_PWR_NOTIFICATION_READ_LEN    1

#define TI_BlueLock_BATT_SERVICE_UUID                         0xFFB0
#define TI_BlueLock_LEVEL_SERVICE_UUID                        0xFFB1
#define TI_BlueLock_POWER_STATE_UUID                          0xFFB2
#define TI_BlueLock_LEVEL_SERVICE_READ_LEN                    1

#define TI_BlueLock_ACCEL_SERVICE_UUID                        0xFFA0
#define TI_BlueLock_ACCEL_ENABLER_UUID                        0xFFA1
#define TI_BlueLock_ACCEL_RANGE_UUID                          0xFFA2
#define TI_BlueLock_ACCEL_READ_LEN                            1
#define TI_BlueLock_ACCEL_X_UUID                              0xFFA3
#define TI_BlueLock_ACCEL_Y_UUID                              0xFFA4
#define TI_BlueLock_ACCEL_Z_UUID                              0xFFA5

#define TI_BlueLock_KEYS_SERVICE_UUID                         0xFFE0
#define TI_BlueLock_KEYS_NOTIFICATION_UUID                    0xFFE1
#define TI_BlueLock_KEYS_NOTIFICATION_READ_LEN                1

#endif
