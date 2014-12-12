//
//  Utility.h
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int ProjectileSpeed = 400;
static const int SpaceDogMinSpeed = -100;
static const int SpaceDogMaxSpeed = -50;
static const int MaxLives = 4;
static const int PointsPerHit = 100;

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryEnemy      = 1 << 0,
    CollisionCategoryProjectile = 1 << 1,
    CollisionCategoryDebris     = 1 << 2,
    CollisionCategoryGround     = 1 << 3
};

@interface Utility : NSObject

+(NSInteger) randomWithMin: (NSInteger) min max: (NSInteger) max;

@end
