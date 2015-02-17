//
//  MovieCollectionViewController.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-04.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>


@interface MovieCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@property (nonatomic) PFUser* user; // NOTE: Can be nil

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;

@end

