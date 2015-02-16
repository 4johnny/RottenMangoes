//
//  WelcomeViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MovieCollectionViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	if ([segue.identifier isEqualToString:@"showMovies"]) {
	
		// Inject MOC into movie collection view controller
		MovieCollectionViewController* movieCollectionViewController = (MovieCollectionViewController*)segue.destinationViewController;
		movieCollectionViewController.managedObjectContext = self.managedObjectContext;
	}
}


@end
