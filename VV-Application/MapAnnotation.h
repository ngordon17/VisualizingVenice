//
//  MapAnnotation.h
//  VV-Application
//
//  Created by Nicholas Gordon on 10/18/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/**
 * Initializes map annotation object with given data
 * param: string that represents the title of the annotation, string that represents the address/description of the
 * annotation, and the latitude/longitude of the annotation (i.e. where on a map it should be plotted).e
 * return: self
 */
- (id)initWithName:(NSString*)name address:(NSString*)address latitude:(double) latitude longitude:(double) longitude;

/**
 * Retrieves title of the annotation
 * return: String that is the title of the annotation.
 */
- (NSString *)title;
/**
 * Retrieves subtitle of the annotation
 * return: String that is the subtitle of the annotation.
 */
- (NSString *)subtitle;
@end