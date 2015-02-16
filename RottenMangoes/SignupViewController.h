//
//  SignupViewController.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(uint, FanType) {
	
	FanType_None = 0,
	FanType_MovieCritic,
	FanType_CasualMovieFan
};


@interface SignupViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIPickerView *fanTypePickerView;

@end
