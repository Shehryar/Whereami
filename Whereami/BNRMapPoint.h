//
//  BNRMapPoint.h
//  Whereami
//
//  Created by Shehryar Hussain on 12/12/12.
//  Copyright (c) 2012 Shehryar Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BNRMapPoint : NSObject <MKAnnotation>
{
}
// A new designated initializer for instances of BNRMapPoint
- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;

// A mandatory property of MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// This is an optional property
@property (nonatomic, copy) NSString *title;

@end
