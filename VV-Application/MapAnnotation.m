//
//  MapAnnotation.m
//  VV-Application
//
//  Created by Nicholas Gordon on 10/18/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

/**
 * Initializes map annotation object with given data
 * param: string that represents the title of the annotation, string that represents the address/description of the 
 * annotation, and the latitude/longitude of the annotation (i.e. where on a map it should be plotted).e
 * return: self
 */
- (id)initWithName:(NSString*)name address:(NSString*)address latitude:(double) latitude longitude:(double) longitude {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;
        _coordinate = coordinate;
    }
    return self;
}

/**
 * Retrieves title of the annotation
 * return: String that is the title of the annotation.
 */
- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

/**
 * Retrieves subtitle of the annotation
 * return: String that is the subtitle of the annotation.
 */
- (NSString *)subtitle {
    return _address;
}


@end