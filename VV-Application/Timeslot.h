//
//  Timeslot.h
//  VV-Application
//
//  Created by Kuang Han on 12/14/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Timeslot : NSManagedObject

@property (nonatomic, retain) NSString * insula_general_description;
@property (nonatomic, retain) NSString * insula_general_picture;
@property (nonatomic, retain) NSString * landmark_general_description;
@property (nonatomic, retain) NSString * landmark_general_picture;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * year;

@end
