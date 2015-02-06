//
//  ViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-04.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "FooterCollectionReusableView.h"
#import "ReviewsViewController.h"
#import "Movie.h"


#
# pragma mark - Constants
#


#define API_PAGE_LIMIT_MAX	50
#define PAGE_LIMIT			((int)API_PAGE_LIMIT_MAX)

#define API_VER								@"v1.0"
#define API_BASE_URL_FORMAT 				@"http://api.rottentomatoes.com/api/public/%@/"
#define JSON_CMD_IN_THEATRE_MOVIES_FORMAT	@"lists/movies/in_theaters.json?page_limit=%d&page=%d&apikey=%@"
//#define JSON_CMD_IN_THEATRE_MOVIES_FORMAT	@"lists/movies/in_theaters.json?_prettyprint=true&page_limit=%d&page=%d&apikey=%@"

#define CELL_BUFFER_SIZE	10 // Points


#
# pragma mark - Interface
#


@interface MovieCollectionViewController ()

#
# pragma mark Properties
#

@property (nonatomic) int totalInTheatreMovies;
@property (nonatomic) int currentPageNumber;
@property (nonatomic) NSMutableArray* inTheatreMovies;
@property (nonatomic) NSMutableData* rottenTomatoesResponseData;

@end


#
# pragma mark - Implementation
#


@implementation MovieCollectionViewController


#
# pragma mark UIViewController
#


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.totalInTheatreMovies = 0;
	self.currentPageNumber = 0;
	self.inTheatreMovies = [NSMutableArray array];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
	// Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"showReviews"]) {

		NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
		Movie* movie = self.inTheatreMovies[indexPath.item];
		
		ReviewsViewController* controller = (ReviewsViewController*)segue.destinationViewController;
		controller.movie = movie;
	}
}


#
# pragma mark <UICollectionViewDataSource>
#


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
	
	return 1;
}


- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return self.inTheatreMovies.count;
}


- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
	
	// Configure the cell
	
	MovieCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollectionViewCell" forIndexPath:indexPath];
	
	Movie* movie = (Movie*)self.inTheatreMovies[indexPath.item];
	cell.resultNumberLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.item + 1];
	cell.idLabel.text = movie.id;
	cell.titleLabel.text = movie.title;
	cell.yearLabel.text = [NSString stringWithFormat:@"%d", movie.year];
	cell.mpaaRatingLabel.text = movie.mpaaRating;
	cell.runtimeLabel.text = [NSString stringWithFormat:@"%d", movie.runtime];
	cell.criticsConcensusLabel.text = movie.criticsConsensus;
	cell.synopsisLabel.text = movie.synopsis;
	
	return cell;
}


- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath {

	// Configure the supplementary element: view or decoration
	
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		
		return nil;
	}
	
	if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

		FooterCollectionReusableView* footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"inTheatreMoviesFooter" forIndexPath:indexPath];
		
		// Lazy-load data when footer becomes visible
		[self loadPagedDataModel:footerView];
		
		return footerView;
	}
	
	return nil; // NOTE: We should never get here!
}


/*
#
# pragma mark <UICollectionViewDelegate>
#


- (BOOL)collectionView:(UICollectionView*)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath*)indexPath {
 
	// Determine if the specified item should be highlighted during tracking
	
	return YES; // Default YES
}


- (BOOL)collectionView:(UICollectionView*)collectionView shouldSelectItemAtIndexPath:(NSIndexPath*)indexPath {
	
	// Determine if the specified item should be selected
	
	return YES; // Default YES
}


- (BOOL)collectionView:(UICollectionView*)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath*)indexPath {
	
	// Determine if an action menu should be displayed for the specified item, and react to actions performed on the item
	
	return NO; // Default NO
}


- (BOOL)collectionView:(UICollectionView*)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
	
	// Determine if an action menu should be displayed for the specified item, and react to actions performed on the item
	
	return NO; // Default NO
}


- (void)collectionView:(UICollectionView*)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
 
 // Determine if an action menu should be displayed for the specified item, and react to actions performed on the item
}
*/


#
# pragma mark <UICollectionViewDelegateFlowLayout>
#


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {

	CGFloat width = self.collectionView.bounds.size.width;
	CGFloat height = self.collectionView.bounds.size.height;
	
	switch ([UIDevice currentDevice].orientation) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
			return CGSizeMake(width - CELL_BUFFER_SIZE * 2, height - CELL_BUFFER_SIZE * 2);
			
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			return CGSizeMake(width - CELL_BUFFER_SIZE * 2, height); //- CELL_BUFFER_SIZE * 2);
			
		case UIDeviceOrientationUnknown:
			break;
	}

	// return CGSizeMake(315, 315);
	return ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize;
}


-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	
	return UIEdgeInsetsMake(CELL_BUFFER_SIZE, CELL_BUFFER_SIZE, CELL_BUFFER_SIZE, CELL_BUFFER_SIZE);

//	return ((UICollectionViewFlowLayout*)collectionViewLayout).sectionInset;
}


- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	
	switch ([UIDevice currentDevice].orientation) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
			return CELL_BUFFER_SIZE;
			
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			return CELL_BUFFER_SIZE;
			
		case UIDeviceOrientationUnknown:
			break;
	}

	return CELL_BUFFER_SIZE;
	
//	return ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
}


- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	
	switch ([UIDevice currentDevice].orientation) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
			return CELL_BUFFER_SIZE;
			
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			return CELL_BUFFER_SIZE;
			
		case UIDeviceOrientationUnknown:
			break;
	}
	
	return CELL_BUFFER_SIZE;
	
//	return ((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
}

/*
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
 
	//	return CGSizeMake(150, 150);
	
	return ((UICollectionViewFlowLayout*)collectionViewLayout).headerReferenceSize;
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
 
	//	return CGSizeMake(150, 150);
	
	return ((UICollectionViewFlowLayout*)collectionViewLayout).footerReferenceSize;
}
*/

/*
#
# pragma mark <NSURLConnectionDataDelegate>
#


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// NOTE: Possibly called multiple times
	
	MDLog(@"Received Response");
	self.rottenTomatoesResponseData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	MDLog(@"Received Data: %d bytes", (int)data.length);
	[self.rottenTomatoesResponseData appendData:data];
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	
	MDLog(@"Will Cache Response: NO");
	return nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	NSError* error = nil;
	NSMutableDictionary* moviesJSON = [NSJSONSerialization JSONObjectWithData:self.rottenTomatoesResponseData options:kNilOptions error:&error];
	
	if (!moviesJSON) {
		MDLog(@"Finished Loading Error - %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
		return;
	}
	
	MDLog(@"Movies JSON: %@", moviesJSON);
	[self appendMoviesWithJSON:moviesJSON];
	MDLog(@"Movies: %@", self.inTheatreMovies);
}


#
# pragma mark <NSURLConnectionDelegate>
#


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	MDLog(@"Connection Error - %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	self.rottenTomatoesResponseData = nil;
}
*/


#
# pragma mark <UIContentContainer>
#

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	
	// Happens when orientation changes
	// Force layout to redraw
	[self.collectionViewLayout invalidateLayout];
}


#
# pragma mark Helpers
#


- (void)loadPagedDataModel:(FooterCollectionReusableView*)footerView {
	
	// If we have retrieved all pages of data, we are done.
	if (self.currentPageNumber >= (self.totalInTheatreMovies / PAGE_LIMIT) + 1) return;
	
	[footerView showLoadingUI];
	
	// Build Rotten Tomatoes API command URL
	NSMutableString* commandStr = [NSMutableString stringWithFormat:API_BASE_URL_FORMAT, API_VER];
	[commandStr appendFormat:JSON_CMD_IN_THEATRE_MOVIES_FORMAT, PAGE_LIMIT, self.currentPageNumber + 1, API_KEY_ROTTEN_TOMATOES];
	NSURL* commandUrl = [NSURL URLWithString:commandStr];
	MDLog(@"%@", commandUrl)
	NSMutableURLRequest* urlReq = [NSMutableURLRequest requestWithURL:commandUrl];
	urlReq.HTTPMethod = @"GET";
	
	// Create and fire URL connection request
	// NOTE: No retain cycle on self in block, since we know completion handler is run and discarded
	[NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		
		if (!data) {
			MDLog(@"URL Connection Error - %@ %@", connectionError.localizedDescription, [connectionError.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
			[footerView cancelLoadingUI];
			return;
		}
		
		NSError* error = nil;
		NSDictionary* moviesJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (!moviesJSONDictionary) {
			MDLog(@"JSON Deserialization Error - %@ %@", error.localizedDescription, error.userInfo);
			[footerView cancelLoadingUI];
			return;
		}
		// MDLog(@"Movies JSON: %@", moviesJSONDictionary);
		self.currentPageNumber++;
		
		self.totalInTheatreMovies = ((NSString*)moviesJSONDictionary[@"total"]).intValue;
		[self appendMoviesWithJSON:moviesJSONDictionary[@"movies"]];
		// MDLog(@"Movies: %@", self.inTheatreMovies);
		[self.collectionView reloadData];
		[footerView cancelLoadingUI];
	}];
	
	// [NSURLConnection connectionWithRequest:urlReq delegate:self]; // Finer-grain control via delegate
}


- (void)appendMoviesWithJSON:(NSArray*)moviesJSON {

	for (id movieJSON in moviesJSON) {
		
		Movie* movie = [Movie movie];
		movie.id = movieJSON[@"id"];
		movie.title = movieJSON[@"title"];
		movie.year = ((NSString*)movieJSON[@"year"]).intValue;
		movie.mpaaRating = movieJSON[@"mpaa_rating"];
		movie.runtime = ((NSString*)movieJSON[@"runtime"]).intValue;
		movie.criticsConsensus = movieJSON[@"critics_consensus"];
		movie.synopsis = movieJSON[@"synopsis"];
		movie.reviewsURL = [NSURL URLWithString:movieJSON[@"links"][@"reviews"]];
		
		[self.inTheatreMovies addObject:movie];
	}
}


@end
