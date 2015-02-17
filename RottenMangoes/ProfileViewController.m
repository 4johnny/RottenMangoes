//
//  SignupViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "Util.h"


@interface ProfileViewController ()


@end


@implementation ProfileViewController


#
# pragma mark UIViewController
#


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.usernameLabel.text = self.user.username;
	
	PFFile* avatarJPEGFile = self.user[@"avatarJPEGFile"];
	[avatarJPEGFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		
		if (!error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				self.avatarImageView.image = [UIImage imageWithData:data];
			});
			return;
		}
		
		NSLog(@"Parse Image Load Error: %@ %@", error.localizedDescription, error.userInfo);
	}];
	
	self.fanTypeLabel.text = (NSString*)self.user[@"fanType"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
