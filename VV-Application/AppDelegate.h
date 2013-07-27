//
//  AppDelegate.h
//  VV-Application
//
//  Created by Nicholas Gordon on 10/5/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "PublicLibrary.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CoreData *coreData;
@property (strong, nonatomic) PublicLibrary *lib;
@end
