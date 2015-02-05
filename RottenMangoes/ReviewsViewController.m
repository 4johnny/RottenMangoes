//
//  ReviewsViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-05.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "ReviewsViewController.h"


#define PAGE_LIMIT	3
#define PAGE_NUMBER	1

#define JSON_REVIEWS_CMD_FORMAT	@"%@?page_limit=%d&apikey=%@"


@interface ReviewsViewController ()

@property (nonatomic) NSMutableArray* reviews;

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.reviews = [NSMutableArray arrayWithCapacity:PAGE_LIMIT];

	self.review1Label.text = @"";
	self.review2Label.text = @"";
	self.review3Label.text = @"";
	
	// Build Rotten Tomatoes API command URL
	NSMutableString* commandStr = [NSMutableString stringWithFormat:JSON_REVIEWS_CMD_FORMAT, self.movie.reviewsURL.absoluteString, PAGE_LIMIT, API_KEY_ROTTEN_TOMATOES];
	NSURL* commandUrl = [NSURL URLWithString:commandStr];
	MDLog(@"%@", commandUrl)
	
	// Create and fire URL connection request
	// NOTE: No retain cycle on self in block, since we know completion handler is run and discarded
	NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:commandUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		if (!data) {
			MDLog(@"URL Connection Error - %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
			return;
		}
		
		error = nil;
		NSDictionary* reviewsJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (!reviewsJSON) {
			MDLog(@"JSON Deserialization Error - %@ %@", error.localizedDescription, error.userInfo);
			return;
		}
		
		MDLog(@"Reviews JSON: %@", reviewsJSON);
		[self populateReviewsWithJSON:reviewsJSON];
		MDLog(@"Reviews: %@", self.reviews);

		[self performSelectorOnMainThread:@selector(configureView) withObject:nil waitUntilDone:NO];
		// dispatch_async(dispatch_get_main_queue(), ^{
		//	[self configureView];
		// }); // Works just as well, with finer-grain control options
		// [self configureView]; // NOTE: Works, but UI should be on main thread
	}];
	
	[dataTask resume];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)donePressed:(UIBarButtonItem *)sender {
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

#
# pragma mark Helpers
#


- (void)populateReviewsWithJSON:(NSDictionary*)reviewsJSON {
	
	for (id reviewJSON in reviewsJSON[@"reviews"]) {

		NSString* review = reviewJSON[@"quote"];

		[self.reviews addObject:review];
	}
}


- (void)configureView {

	if (self.reviews.count < 3) return;
	
	self.review1Label.text = self.reviews[0];
	self.review2Label.text = self.reviews[1];
	self.review3Label.text = self.reviews[2];
}


@end
