//
//  ReviewsViewController.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-05.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface ReviewsViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) Movie* movie;

@property (weak, nonatomic) IBOutlet UILabel *date1Label;
@property (weak, nonatomic) IBOutlet UILabel *critic1Label;
@property (weak, nonatomic) IBOutlet UILabel *quote1Label;

@property (weak, nonatomic) IBOutlet UILabel *date2Label;
@property (weak, nonatomic) IBOutlet UILabel *critic2Label;
@property (weak, nonatomic) IBOutlet UILabel *quote2Label;

@property (weak, nonatomic) IBOutlet UILabel *date3Label;
@property (weak, nonatomic) IBOutlet UILabel *critic3Label;
@property (weak, nonatomic) IBOutlet UILabel *quote3Label;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingReviewsActivityIndicatorView;

@end
