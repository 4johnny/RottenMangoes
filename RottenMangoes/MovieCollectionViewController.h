//
//  MovieCollectionViewController.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-04.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface MovieCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;

@end

