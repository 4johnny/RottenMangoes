//
//  Movie.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-04.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSString* id;
@property (nonatomic) NSString* title;
@property (nonatomic) int year;
@property (nonatomic) NSString* mpaaRating;
@property (nonatomic) int runtime;
@property (nonatomic) NSString* criticsConsensus;
@property (nonatomic) NSString* synopsis;
@property (nonatomic) NSURL* reviewsURL;

+ (Movie *)movie;

@end
