//
//  ReviewsViewController.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-05.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface ReviewsViewController : UIViewController

@property (nonatomic) Movie* movie;

@property (weak, nonatomic) IBOutlet UILabel *review1Label;
@property (weak, nonatomic) IBOutlet UILabel *review2Label;
@property (weak, nonatomic) IBOutlet UILabel *review3Label;

@end
