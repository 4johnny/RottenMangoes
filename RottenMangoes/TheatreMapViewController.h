//
//  TheatreMapViewController.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-08.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Movie.h"

@interface TheatreMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) Movie* movie;

@property (weak, nonatomic) IBOutlet MKMapView *theatreMapView;

@end
