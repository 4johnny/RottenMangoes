//
//  ReviewsViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-05.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "ReviewsViewController.h"
#import "AppDelegate.h"
#import "Review.h"


#
# pragma mark - Constants
#


#define PAGE_LIMIT	3
#define PAGE_NUMBER	1

#define JSON_REVIEWS_CMD_FORMAT	@"%@?page_limit=%d&apikey=%@"


#
# pragma mark - Interface
#


@interface ReviewsViewController ()


#
# pragma mark Properties
#

@property (strong, nonatomic) NSFetchedResultsController *reviewsFetchedResultsController;


@end


#
# pragma mark - Implementation
#


@implementation ReviewsViewController


#
# pragma mark Property Accessors
#


- (NSFetchedResultsController*)reviewsFetchedResultsController {
	
	if (_reviewsFetchedResultsController) return _reviewsFetchedResultsController;
	
	// Create fetch request for reviews
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Review"];
	fetchRequest.fetchBatchSize = PAGE_LIMIT;
	fetchRequest.fetchLimit = PAGE_LIMIT;
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
//	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"movie.id == %@", self.movie.id];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	_reviewsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.movie.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	_reviewsFetchedResultsController.delegate = self;
	
	NSError *error = nil;
	if ([_reviewsFetchedResultsController performFetch:&error]) return _reviewsFetchedResultsController;
	
	// TODO: Replace this with code to handle the error appropriately.
	// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	NSLog(@"Unresolved error %@, %@", error, error.userInfo);
	abort();
	
	return _reviewsFetchedResultsController;
}


#
# pragma mark UIViewController
#


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self initializeView];
	
	// If we have already loaded review data, we are done.
	if (self.reviewsFetchedResultsController.fetchedObjects.count > 0) return;
	
	[self showLoadingUI];
	
	// Build Rotten Tomatoes API command URL
	NSMutableString* commandStr = [NSMutableString stringWithFormat:JSON_REVIEWS_CMD_FORMAT, self.movie.reviewsURL, PAGE_LIMIT, API_KEY_ROTTEN_TOMATOES];
	NSURL* commandUrl = [NSURL URLWithString:commandStr];
	MDLog(@"%@", commandUrl)
	
	// Create and fire URL connection request
	// NOTE: No retain cycle on self in block, since we know completion handler is run and discarded
	NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:commandUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		if (!data) {
			MDLog(@"URL Connection Error - %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
			[self performSelectorOnMainThread:@selector(cancelLoadingUI) withObject:nil waitUntilDone:NO];
			return;
		}
		
		// We have data - convert it to JSON dictionary
		error = nil;
		NSDictionary* reviewsJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (!reviewsJSONDictionary) {
			MDLog(@"JSON Deserialization Error - %@ %@", error.localizedDescription, error.userInfo);
			[self performSelectorOnMainThread:@selector(cancelLoadingUI) withObject:nil waitUntilDone:NO];
			return;
		}
		// MDLog(@"Reviews JSON: %@", reviewsJSONDictionary);
		
		// We have JSON dictionary - convert it to review objects
		[self populateReviewsWithJSON:reviewsJSONDictionary[@"reviews"]];
		// MDLog(@"Reviews: %@", self.reviews);
		[self performSelectorOnMainThread:@selector(configureView) withObject:nil waitUntilDone:NO];
		// dispatch_async(dispatch_get_main_queue(), ^{
		//	[self configureView];
		// }); // Works just as well, with finer-grain control options
		// [self configureView]; // NOTE: "Works" - but UI should be done on main thread
		[self performSelectorOnMainThread:@selector(cancelLoadingUI) withObject:nil waitUntilDone:NO];
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


#
# pragma mark <NSFetchedResultsControllerDelegate>
#


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	// NOTE: Even if method is empty, at least one protocol method must be implemented for fetch-results controller to track changes
	
}


#
# pragma mark Helpers
#


- (void)populateReviewsWithJSON:(NSArray*)reviewsJSON {
	
	for (id reviewJSON in reviewsJSON) {

		Review* review = [NSEntityDescription insertNewObjectForEntityForName:@"Review" inManagedObjectContext:self.movie.managedObjectContext];

		review.critic = reviewJSON[@"critic"];
		review.freshness = reviewJSON[@"freshness"];
		review.publication = reviewJSON[@"publication"];
		review.quote = reviewJSON[@"quote"];

		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
		review.date = [dateFormatter dateFromString:reviewJSON[@"date"]];
		
		review.movie = self.movie;
		[self.movie addReviewsObject:review];
	}
	
	[ReviewsViewController saveManagedObjectContext];
}


- (void)initializeView {

	self.review1Label.hidden = YES;
	self.review2Label.hidden = YES;
	self.review3Label.hidden = YES;
}


- (void)configureView {

	// Configure up to 3 reviews
	NSUInteger reviewsCount = self.reviewsFetchedResultsController.fetchedObjects.count;
	
	if (reviewsCount < 1) {
		self.review1Label.text = @"No reviews";
		return;
	}
	
	self.review1Label.text = ((Review *)self.reviewsFetchedResultsController.fetchedObjects[0]).quote;
	self.review1Label.hidden = NO;
	
	if (reviewsCount < 2) return;
	
	self.review2Label.text = ((Review *)self.reviewsFetchedResultsController.fetchedObjects[1]).quote;
	self.review2Label.hidden = NO;
	
	if (reviewsCount < 3) return;
	
	self.review3Label.text = ((Review *)self.reviewsFetchedResultsController.fetchedObjects[2]).quote;
	self.review3Label.hidden = NO;
}


- (void)showLoadingUI {
	
	self.review1Label.hidden = YES;
	[self.loadingReviewsActivityIndicatorView startAnimating];
}


- (void)cancelLoadingUI {
	
	self.review1Label.hidden = NO;
	[self.loadingReviewsActivityIndicatorView stopAnimating];
}


+ (void) saveManagedObjectContext {
	
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate saveContext];
}


@end
