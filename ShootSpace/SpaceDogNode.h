//
//  SpaceDogNode.h
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, SpaceDogType) {
    SpaceDogTypeA = 0,
    SpaceDogTypeB = 1
};

@interface SpaceDogNode : SKSpriteNode
+ (instancetype) spaceDogOfType: (SpaceDogType) type;
@end
