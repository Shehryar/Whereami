//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Shehryar Hussain on 12/7/12.
//  Copyright (c) 2012 Shehryar Hussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *locationTitleField;
    __weak IBOutlet UISegmentedControl *mapTypeControl;
}

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;

- (IBAction)changeMapType:(id)sender;



@end

