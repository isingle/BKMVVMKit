//
//  BKVMViewController.m
//  BKMVVMKit
//
//  Created by isingle on 09/06/2019.
//  Copyright (c) 2019 isingle. All rights reserved.
//

#import "BKVMViewController.h"
#import "BKRoleManagerViewController.h"
#import "BKPinViewController.h"

@interface BKVMViewController ()

@end

@implementation BKVMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Demo";
}

- (IBAction)pushTableViewController:(id)sender
{
    BKRoleManagerViewController *roleVC = [[BKRoleManagerViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:roleVC animated:YES];
}

- (IBAction)pushCollectionVC:(id)sender
{
    BKPinViewController *pinVC = [[BKPinViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:pinVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
