//
//  Landmark.h
//  VV-Application
//
//  Created by Kuang Han on 12/14/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Intermediate, Timeslot;

@interface Landmark : NSManagedObject

@property (nonatomic, retain) NSString * insula_name;
@property (nonatomic, retain) NSString * landmark_3d;
@property (nonatomic, retain) NSString * landmark_annotation_description;
@property (nonatomic, retain) NSString * landmark_annotation_picture;
@property (nonatomic, retain) NSString * landmark_general_description;
@property (nonatomic, retain) NSString * landmark_general_picture;
@property (nonatomic, retain) NSString * landmark_name;
@property (nonatomic, retain) NSString * landmark_video;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *intermediates;
@property (nonatomic, retain) NSSet *timeslots;
@end

@interface Landmark (CoreDataGeneratedAccessors)

- (void)addIntermediatesObject:(Intermediate *)value;
- (void)removeIntermediatesObject:(Intermediate *)value;
- (void)addIntermediates:(NSSet *)values;
- (void)removeIntermediates:(NSSet *)values;

- (void)addTimeslotsObject:(Timeslot *)value;
- (void)removeTimeslotsObject:(Timeslot *)value;
- (void)addTimeslots:(NSSet *)values;
- (void)removeTimeslots:(NSSet *)values;

@end
