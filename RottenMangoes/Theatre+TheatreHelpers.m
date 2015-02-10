//
//  Theatre+TheatreHelpers.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-10.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Theatre+TheatreHelpers.h"
#import "AppDelegate.h"


#
# pragma mark - Implementation
#


@implementation Theatre (TheatreHelpers)


#
# pragma mark <MKAnnotation>
#

- (CLLocationCoordinate2D)coordinate {

	return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}


- (NSString*)title {
	
	return self.name;
}


- (NSString*)subtitle {
	
	return self.address;
}


#
# pragma mark Helpers
#


+ (Theatre*)theatreWithName:(NSString*)name {

	// Grab MOC from app delegate
	AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* moc = appDelegate.managedObjectContext;
	
	// Create fetch request for theatres
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Theatre"];
	fetchRequest.fetchBatchSize = 1;
	fetchRequest.fetchLimit = 1;
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
	
	// If theater exists, return it
	NSError *error = nil;
	if ([fetchedResultsController performFetch:&error]) {
		
		if (fetchedResultsController.fetchedObjects.count > 0)
			return fetchedResultsController.fetchedObjects.firstObject;
		
	} else {
	
		// TODO: Replace this with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}

	// Theatre does not exist, so insert new one
	Theatre* theatre = [NSEntityDescription insertNewObjectForEntityForName:@"Theatre" inManagedObjectContext:moc];
	theatre.name = name;
	
	return theatre;
}


@end
