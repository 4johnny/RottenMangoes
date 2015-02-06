//
//  FooterCollectionReusableView.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-05.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "FooterCollectionReusableView.h"

@implementation FooterCollectionReusableView


- (void)showLoadingUI {
	
	self.noMoreMoviesLabel.hidden = YES;
	[self.loadingMoviesActivityIndicatorView startAnimating];
}


- (void)cancelLoadingUI {
	
	[self.loadingMoviesActivityIndicatorView stopAnimating];
	self.noMoreMoviesLabel.hidden = NO;
}


@end
