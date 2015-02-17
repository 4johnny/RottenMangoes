//
//  Util.m
//  RottenMangoes
//
//  Created by Johnny on 2015-02-16.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "Util.h"


@interface Util ()

@property (nonatomic) NSArray* fanTypes;

@end



@implementation Util


#
# pragma mark Static
#


static NSArray* fanTypes = nil;



#
# pragma mark Property Accessors
#

+ (NSArray*)fanTypes {
	
	if (fanTypes) return fanTypes;
	
	fanTypes = @[@"None",
				 @"Movie Critic",
				 @"Casual Movie Fan"
				 ];
	
	return fanTypes;
}


@end
