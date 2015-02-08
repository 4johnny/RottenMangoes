//
//  ShowTime.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-08.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface ShowTime : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) NSManagedObject *theatre;

@end
