//
//  SignupViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Parse/Parse.h>
#import "SignupViewController.h"


@interface SignupViewController ()

@property (nonatomic) NSArray* fanTypes;

@end


@implementation SignupViewController


#
# pragma mark Property Accessors
#


- (NSArray*)fanTypes {
	
	if (_fanTypes) return _fanTypes;
	
	_fanTypes = @[@"None",
				  @"Movie Critic",
				  @"Casual Movie Fan"
				  ];
	
	return _fanTypes;
}


#
# pragma mark UIViewController
#


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.fanTypePickerView.delegate = self;
	[self.fanTypePickerView selectRow:0 inComponent:0 animated:NO];
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


#
# pragma mark <UIPickerViewDataSource>
#


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	if (pickerView == self.fanTypePickerView) return 1;
	
	return 0;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

	if (pickerView == self.fanTypePickerView) return 2;
	
	return 0;
}


#
# pragma mark <UIPickerViewDelegate>
#


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	if (pickerView == self.fanTypePickerView) return self.fanTypes[row + 1];
	
	return nil;
}


#
# pragma mark Action Handlers
#


- (IBAction)savePressed:(UIBarButtonItem *)sender {
	
	PFUser* user = [PFUser user];
	user.username = self.userNameTextField.text;
	user.password = @"password";

	// NOTE: Parse's limit for NSData is 128KB, so use PFFile with limit 10MB
	// NOTE: PNG representation blows up 1.7MB file to 12MB!
	// TODO: Consider storing image files to disk and creating PFFile directly, without NSData
	NSData* avatarJPEGData = UIImageJPEGRepresentation(self.avatarImageView.image, 1.0);
	user[@"avatarJPEGFile"] = [PFFile fileWithName:@"avatar.jpg" data:avatarJPEGData];
	
	user[@"fanType"] = (NSString*)self.fanTypes[[self.fanTypePickerView selectedRowInComponent:0] + 1];
	
	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		
		NSString* alertMessage = @"Signup successful";
		if (!succeeded) {
			
			alertMessage = @"Signup failed - try another username";
			NSLog(@"Signup error %@ %@", error.localizedDescription, error.userInfo);
		}
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			
			[self.navigationController popViewControllerAnimated:YES];
		}];
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Signup" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:defaultAction];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[self.navigationController presentViewController:alert animated:YES completion:nil];
		});
	}];
}


@end
