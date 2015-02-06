//
//  FooterCollectionReusableView.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-05.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingMoviesActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *noMoreMoviesLabel;

- (void)showLoadingUI;
- (void)cancelLoadingUI;

@end
