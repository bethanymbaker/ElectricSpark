//
//  ElectricSparkViewController.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/22/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "ElectricSparkViewController.h"
#import "ElectricSparkView.h"
#import "Electron.h"

@interface ElectricSparkViewController ()
@end

@implementation ElectricSparkViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view = [[ElectricSparkView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        return self;
    } else {
        return nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
