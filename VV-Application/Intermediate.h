//
//  Intermediate.h
//  VV-Application
//
//  Created by Kuang Han on 12/14/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Popover;

@interface Intermediate : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSSet *popovers;
@end

@interface Intermediate (CoreDataGeneratedAccessors)

- (void)addPopoversObject:(Popover *)value;
- (void)removePopoversObject:(Popover *)value;
- (void)addPopovers:(NSSet *)values;
- (void)removePopovers:(NSSet *)values;

@end
