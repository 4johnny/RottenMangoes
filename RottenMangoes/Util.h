//
//  Util.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


#
# pragma mark - Constants
#

static const BOOL PARSE_ENABLED = YES;
static const BOOL ICLOUD_ENABLED = NO;


#
# pragma mark - Enums
#


typedef NS_ENUM(NSInteger, FanType) {
	
	FanType_None = 0,
	FanType_MovieCritic,
	FanType_CasualMovieFan
};


#
# pragma mark - Interface
#


@interface Util : NSObject

+ (NSArray*)fanTypes;

@end
