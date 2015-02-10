//
//  Theatre+TheatreHelpers.h
//  RottenMangoes
//
//  Created by Johnny on 2015-02-10.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "Theatre.h"

#
# pragma mark - Interface
#

@interface Theatre (TheatreHelpers) <MKAnnotation>

#
# pragma mark Helpers
#

+ (Theatre*)theatreWithName:(NSString*)name;

@end
