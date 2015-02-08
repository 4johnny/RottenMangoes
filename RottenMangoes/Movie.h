//
//  Movie.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-08.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Review, ShowTime;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * criticsConsensus;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * mpaaRating;
@property (nonatomic, retain) NSData * posterImage;
@property (nonatomic, retain) NSString * reviewsURL;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *reviews;
@property (nonatomic, retain) NSSet *showTimes;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSSet *)values;
- (void)removeReviews:(NSSet *)values;

- (void)addShowTimesObject:(ShowTime *)value;
- (void)removeShowTimesObject:(ShowTime *)value;
- (void)addShowTimes:(NSSet *)values;
- (void)removeShowTimes:(NSSet *)values;

@end
