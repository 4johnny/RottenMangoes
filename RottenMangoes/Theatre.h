//
//  Theatre.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-08.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShowTime;

@interface Theatre : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *showTimes;
@end

@interface Theatre (CoreDataGeneratedAccessors)

- (void)addShowTimesObject:(ShowTime *)value;
- (void)removeShowTimesObject:(ShowTime *)value;
- (void)addShowTimes:(NSSet *)values;
- (void)removeShowTimes:(NSSet *)values;

@end
