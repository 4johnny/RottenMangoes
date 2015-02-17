//
//  WelcomeViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Parse/Parse.h>
#import "WelcomeViewController.h"
#import "MovieCollectionViewController.h"
#import "ProfileViewController.h"


@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Test Parse
	//	PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
	//	testObject[@"foo"] = @"bar";
	//	[testObject saveInBackground];
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
		movieCollectionViewController.user = self.user;
		
	} else if ([segue.identifier isEqualToString:@"showProfile"]) {
		
		// Inject user into profile view controller
		ProfileViewController* profileViewController = (ProfileViewController*)segue.destinationViewController;
		profileViewController.user = self.user;
	}
}


- (IBAction)loginPressed:(UIButton *)sender {
	
	self.user = nil;

	[PFUser logInWithUsernameInBackground:self.usernameTextField.text password:@"password" block:^(PFUser *user, NSError *error) {
		
		if (!error) {
			
			self.user = user;
			
			dispatch_async(dispatch_get_main_queue(), ^{
				
				[self performSegueWithIdentifier:@"showMovies" sender:self];
			});
			
			return;
		}
		
		NSLog(@"Login error: %@ %@", error.localizedDescription, error.userInfo);
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		NSString* alertMessage = @"Login failed";
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:defaultAction];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[self.navigationController presentViewController:alert animated:YES completion:nil];
		});
	}];
}


@end
