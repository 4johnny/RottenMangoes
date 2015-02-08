//
//  Review.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-08.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Review : NSManagedObject

@property (nonatomic, retain) NSString * critic;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * freshness;
@property (nonatomic, retain) NSString * publication;
@property (nonatomic, retain) NSString * quote;
@property (nonatomic, retain) NSManagedObject *movie;

@end
