//
//  ViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-04.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "ReviewsViewController.h"
#import "Movie.h"


#define PAGE_LIMIT	50
#define PAGE_NUMBER	1

#define API_VER								@"v1.0"
#define API_BASE_URL_FORMAT 				@"http://api.rottentomatoes.com/api/public/%@/"
#define JSON_CMD_IN_THEATRE_MOVIES_FORMAT	@"lists/movies/in_theaters.json?page_limit=%d&page=%d&apikey=%@"
//#define JSON_CMD_IN_THEATRE_MOVIES_FORMAT	@"lists/movies/in_theaters.json?_prettyprint=true&page_limit=%d&page=%d&apikey=%@"


@interface MovieCollectionViewController ()

@property (nonatomic) NSMutableArray* inTheatreMovies;
//@property (nonatomic) NSDictionary* inTheatreMoviesJSON;
@property (nonatomic) NSMutableData* rottenTomatoesResponseData;

@end


@implementation MovieCollectionViewController


#
# pragma mark UIViewController
#

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
}


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.inTheatreMovies = [NSMutableArray array];
	
	// Build Rotten Tomatoes API command URL
	NSMutableString* commandStr = [NSMutableString stringWithFormat:API_BASE_URL_FORMAT, API_VER];
	[commandStr appendFormat:JSON_CMD_IN_THEATRE_MOVIES_FORMAT, PAGE_LIMIT, PAGE_NUMBER, API_KEY_ROTTEN_TOMATOES];
	NSURL* commandUrl = [NSURL URLWithString:commandStr];
	MDLog(@"%@", commandUrl)
	NSMutableURLRequest* urlReq = [NSMutableURLRequest requestWithURL:commandUrl];
	urlReq.HTTPMethod = @"GET";
	
	// Create and fire URL connection request
	//	[NSURLConnection connectionWithRequest:urlReq delegate:self]; // Fine-grain control via delegate
	// NOTE: No retain cycle on self in block, since we know completion handler is run and discarded
	[NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

		if (!data) {
		MDLog(@"URL Connection Error - %@ %@", connectionError.localizedDescription, [connectionError.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
			return;
		}

		NSError* error = nil;
		NSDictionary* moviesJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (!moviesJSON) {
			MDLog(@"JSON Deserialization Error - %@ %@", error.localizedDescription, error.userInfo);
			return;
		}
		
		MDLog(@"Movies JSON: %@", moviesJSON);
		[self populateMoviesWithJSON:moviesJSON];
		MDLog(@"Movies: %@", self.inTheatreMovies);

		[self.collectionView reloadData];
	}];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
	// Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"showReviews"]) {

		NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
		Movie* movie = self.inTheatreMovies[indexPath.row];
		
		ReviewsViewController* controller = (ReviewsViewController*)[segue.destinationViewController topViewController];
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
	
	Movie* movie = (Movie*)self.inTheatreMovies[indexPath.row];
	cell.idLabel.text = movie.id;
	cell.titleLabel.text = movie.title;
	cell.yearLabel.text = [NSString stringWithFormat:@"%d", movie.year];
	cell.mpaaRatingLabel.text = movie.mpaaRating;
	cell.runtimeLabel.text = [NSString stringWithFormat:@"%d", movie.runtime];
	cell.criticsConcensusLabel.text = movie.criticsConsensus;
	cell.synopsisLabel.text = movie.synopsis;
	
	return cell;
}


/*
- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath {
	
	UICollectionReusableView* reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
	
	// Configure the supplementary element: view or decoration
	
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		
		return nil;
	}
	
	if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
		
		// NOTE: If a footer is added, then dequeue the view here.
		
		return nil;
	}
	
	return nil; // NOTE: We should never get here!
}
*/


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


#
# pragma mark <UICollectionViewDelegateFlowLayout>
#


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {

	//	return CGSizeMake(200, 200);

	return ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize;
}


-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	
	return UIEdgeInsetsMake(50, 50, 50, 50);

//	return ((UICollectionViewFlowLayout*)collectionViewLayout).sectionInset;
}


- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	
	return 50;
	
//	return ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
}


- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	
	return 50;
	
//	return ((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
 
	//	return CGSizeMake(150, 150);
	
	return ((UICollectionViewFlowLayout*)collectionViewLayout).headerReferenceSize;
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
 
	//	return CGSizeMake(150, 150);
	
	return ((UICollectionViewFlowLayout*)collectionViewLayout).footerReferenceSize;
}


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
	[self populateMoviesWithJSON:moviesJSON];
	MDLog(@"Movies: %@", self.inTheatreMovies);
}


#
# pragma mark <NSURLConnectionDelegate>
#


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	MDLog(@"Connection Error - %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	self.rottenTomatoesResponseData = nil;
}


#
# pragma mark Helpers
#


- (void)populateMoviesWithJSON:(NSDictionary*)moviesJSON {

	for (id movieJSON in moviesJSON[@"movies"]) {
		
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
