//
//  ViewController.h
//  VV-Application
//
//  Created by Nicholas Gordon on 10/5/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController

@property (nonatomic, weak) AppDelegate *myApp;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

/**
 * Additional set up after loading the view
 */
- (void)viewDidLoad;

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
- (void)didReceiveMemoryWarning;

@end
