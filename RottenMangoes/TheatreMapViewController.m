//
//  TheatreMapViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-08.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TheatreMapViewController.h"

/*
 Notes:
 
 - Core Location is more than just GPS. It consists of cell phone tower triangulation (fast, but inaccurate), Wifi detection (medium speed, medium accuracy), and GPS (slow, but really accurate)
 
 - You have to request permission, and as-of iOS 8 this has changed. You need to requestWhenInUseAuthorization before you do a "startUpdatingLocation" call
 
 - You'll also need to have to set the NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription in your info.plist file depending on whether you need location in the background or not.
 
 - For testing purposes, we need a gpx file and to set the scheme (plus probably an xcode restart :-P) to have a location in the simulator (setting location only in simulator probably won't work)
 
 - You can get background location updates for "major changes" on the appdelegate with "didUpdateToLocation" or for ibeacons with beacon regions
 
 - Mapkit is the map view which shows a map a user with our annotations on it
 
 Gotchas:
 
 - If NSLocationAlwaysUsageDecription is not set in your Info.plist, it will silently fail
 
 - You need to “startUpdatingLocation” after you ask a user for permission, so you probably need to call startUpdatingLocation in the permissions changed callback as well as viewdidload
 
 - You need to allocate a corelocation manager and request permissions before you can "showUserLocation" on the map
 
 - You need to set the simulator's location in the project schema before the simulator will have a location
 
 - MKAnnotationView's (and more specifically, the default MKPinAnnotationView) will only be asked of from the map view delegate if it's in the visible area
 */


#
# pragma mark - Interface
#


@interface TheatreMapViewController ()

#
# pragma mark - Properties
#

@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, strong) NSString* postalCode;

@end


#
# pragma mark - Implementation
#


@implementation TheatreMapViewController


#
# pragma mark Property Accessors
#


- (CLLocationManager*)locationManager {

	if (_locationManager) return _locationManager;

	// Request authorization to use location info
	// Start updating location

	CLAuthorizationStatus locationAuthorizationStatus = [CLLocationManager authorizationStatus];
	if (locationAuthorizationStatus != kCLAuthorizationStatusDenied &&
		locationAuthorizationStatus != kCLAuthorizationStatusRestricted) {
		
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		//_locationManager.distanceFilter = kCLDistanceFilterNone; // Default kCLDistanceFilterNone
		
		[_locationManager requestWhenInUseAuthorization];
		
	} else {
		
		MDLog(@"Location Authorization Status: %d", locationAuthorizationStatus);
	}

	return _locationManager;
}


#
# pragma mark UIViewController
#


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Lazy-load location manager
	self.locationManager = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self.locationManager startUpdatingLocation];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self.locationManager stopUpdatingLocation];
}


/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#
# pragma mark <CLLocationManagerDelegate>
#


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

	MDLog(@"locationManager:didChangeAuthorizationStatus %d", status);
	
	if (status != kCLAuthorizationStatusDenied &&
		status != kCLAuthorizationStatusRestricted) {

		[self configureView];
	}
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

	MDLog(@"locationManager:didUpdateLocations %@", locations);
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

	MDLog(@"Location Manager Failed Error - %@ %@", error.localizedDescription, error.userInfo);
}


#
# pragma mark <MKMapViewDelegate>
#


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

	// NOTE: Called many times during scrolling, so keep code lightweight

}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	
	return nil;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {

	return nil;
}


#
# pragma mark Helpers
#


- (void)configureView {

	// Set start region for map to be user's location
	// NOTE: Simulator will use Gastown GPX file
	[self.theatreMapView setRegion:MKCoordinateRegionMake(self.locationManager.location.coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:NO];

	// Reverse geocode user's location to get postal code
	CLGeocoder* geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
		
		// NOTE: Completion block will execute on main thread. Do not run more than one reverse geocode simultaneously.
		
		if (error) {
			MDLog(@"Reverse Geocode Error - %@ %@", error.localizedDescription, error.userInfo);
			return;
		}
		
		if (placemarks.count < 1) {
			MDLog(@"Reverse Geocode No Placemarks");
			return;
		}

		// Grab postal code of first placemark
		CLPlacemark* placemark = placemarks[0];
		MDLog(@"Reverse Geocode Postal Code: %@", placemark.postalCode);
		MDLog(@"Reverse Geocode Address: %@", placemark.addressDictionary);
		self.postalCode = placemark.postalCode; // @"V6B 6B1";
	}];

	//	MKPointAnnotation *marker=[[MKPointAnnotation alloc] init];
	//	CLLocationCoordinate2D iansApartmentLocation;
	//	iansApartmentLocation.latitude = 49.2682029;
	//	iansApartmentLocation.longitude = -123.153424;
	//	marker.coordinate = iansApartmentLocation;
	//	marker.title = @"Ian's Place";
	//	[self.theatreMapView addAnnotation:marker];

	// [self.theatreMapView layoutIfNeeded];
}


@end
