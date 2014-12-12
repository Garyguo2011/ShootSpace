//
//  Utility.m
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSInteger) randomWithMin: (NSInteger) min max: (NSInteger) max {
    return arc4random()%(max - min) + min;
}

@end
