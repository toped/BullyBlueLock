//
//  Tab1Controller.m
//  BullyBlueLock
//
//  Created by CTOstudent on 2/22/14.
//  Copyright (c) 2014 ECEBullyBlueLock. All rights reserved.
//

#import "Tab1Controller.h"

@interface Tab1Controller ()

@end

@implementation Tab1Controller


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"home32.png"];
        self.tabBarItem.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set background based on device type
    UIColor *patternColor;
    patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall@2x.jpg"]];
    self.view.backgroundColor = patternColor;
    
    [self fadein];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fadein{
    [UIImageView beginAnimations:NULL context:Nil];
    [UIImageView setAnimationDuration:2];
    [logo setAlpha:1];
    [UIImageView commitAnimations];
}


@end
