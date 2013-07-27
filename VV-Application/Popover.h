//
//  Popover.h
//  VV-Application
//
//  Created by Kuang Han on 12/14/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Popover : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;

@end
