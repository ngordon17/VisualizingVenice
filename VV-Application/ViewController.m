//
//  ViewController.m
//  VV-Application
//
//  Created by Nicholas Gordon on 10/5/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize myApp = _myApp;
@synthesize textView = _textView;
@synthesize imageView = _imageView;

/**
 * Additional set up after loading the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = [self.myApp.lib getStringFromFile:[self.myApp.coreData.propertyList valueForKey:@"about"]];
    self.textView.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    self.imageView.image = [self.myApp.lib getImageFromFile:[self.myApp.coreData.propertyList valueForKey:@"logo"]];
}

/**
 * Retrieve the app delegate
 * return: App delegate instance
 */
- (AppDelegate *)myApp {
    if (_myApp == NULL) {
        _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _myApp;
}

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
