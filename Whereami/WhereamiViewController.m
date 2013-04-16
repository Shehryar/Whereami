//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Shehryar Hussain on 12/7/12.
//  Copyright (c) 2012 Shehryar Hussain. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@implementation WhereamiViewController

NSString * const WhereamiMapTypePrefKey = @"WhereamiMapTypePrefKey";

+ (void)initialize {
    NSDictionary *defaults = [NSDictionary
                              dictionaryWithObject:[NSNumber numberWithInt:1]
                              forKey:WhereamiMapTypePrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)findLocation {
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
    
}

- (void)foundLocation:(CLLocation *)loc {
    CLLocationCoordinate2D coord = [loc coordinate];
    
    //Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc]initWithCoordinate:coord title:[locationTitleField text]];
    
    // Add it to the map view
    [worldView addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [worldView setRegion:region animated:YES];
    
    // Reset the UI
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];
}

- (IBAction)changeMapType:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setInteger:[sender selectedSegmentIndex] forKey:WhereamiMapTypePrefKey];
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            [worldView setMapType:MKMapTypeStandard];
        } break;
        case 1:
        {
            [worldView setMapType:MKMapTypeSatellite];
        } break;
        case 2:
        {
            [worldView setMapType:MKMapTypeHybrid];
        } break;

    }
    

}

- (void)viewDidLoad
{
    [worldView setShowsUserLocation:YES];
    
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults] integerForKey:WhereamiMapTypePrefKey];
    
    // Update the UI
    [mapTypeControl setSelectedSegmentIndex:mapTypeValue];
    
    // Update the map
    [self changeMapType:mapTypeControl];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Zoom into the user's location when the GPS has located the user
    // Now how do we zoom in?
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        // There will be a warning from this line of code; ignore it for now
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible
        // regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManagers will return the last found location of the device first,
    // you don't want that data in this case.
    // If this location was made more then 3 minutes ago, ignore it
    if (t < -180) {
        return;
    }
    [self foundLocation:newLocation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self findLocation];
    
    [textField resignFirstResponder];
    
    return YES;
}



- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}
@end

