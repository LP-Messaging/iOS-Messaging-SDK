//
//  MainViewController.m
//  SampleApp
//
//  Created by Nir Lachman on 12/02/2018.
//  Copyright © 2018 LivePerson. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)messagingClicked:(id)sender {
    [self performSegueWithIdentifier:@"showMessaging" sender:self];
}
    
- (IBAction)monitoringClicked:(id)sender {
    [self performSegueWithIdentifier:@"showMonitoring" sender:self];
}
    
@end
