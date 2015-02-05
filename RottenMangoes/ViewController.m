//
//  ViewController.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-04.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"


#define API_KEY_ROTTEN_TOMATOES	@"xe4xau69pxaah5tmuryvrw75"

#define PAGE_LIMIT	2
#define PAGE_NUMBER	1

#define API_VER								@"v1.0"
#define API_BASE_URL_FORMAT 				@"http://api.rottentomatoes.com/api/public/%@/"
#define JSON_CMD_IN_THEATRE_MOVIES_FORMAT	@"lists/movies/in_theaters.json?page_limit=%d&page=%d&apikey=%@"
//#define JSON_CMD_IN_THEATRE_MOVIES_FORMAT	@"lists/movies/in_theaters.json?_prettyprint=true&page_limit=%d&page=%d&apikey=%@"


@interface ViewController ()

@property (nonatomic) NSMutableArray* inTheatreMovies;
//@property (nonatomic) NSDictionary* inTheatreMoviesJSON;
@property (nonatomic) NSMutableData* rottenTomatoesResponseData;

@end


@implementation ViewController


#
# pragma mark UIViewController
#


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
	NSError* error = nil;
	[NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

		if (!data) {
		MDLog(@"URL Connection Error - %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
			return;
		}

		NSError* error = nil;
		NSMutableDictionary* moviesJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (!moviesJSON) {
			MDLog(@"JSON Deserialization Error - %@ %@", error.localizedDescription, error.userInfo);
			return;
		}
		
		MDLog(@"Movies JSON: %@", moviesJSON);
		[self populateMoviesWithJSON:moviesJSON];
		MDLog(@"Movies: %@", self.inTheatreMovies);

//		[self.view setNeedsDisplay];
	}];
}


- (void)viewWillAppear:(BOOL)animated {

}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
	// Dispose of any resources that can be recreated.
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
		
		[self.inTheatreMovies addObject:movie];
	}
}


@end
