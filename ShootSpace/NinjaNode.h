//
//  NinjaNode.h
//  ShootSpace
//
//  Created by Gary Guo-I on 12/9/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NinjaNode : SKSpriteNode

+ (instancetype) ninjaAtPosition: (CGPoint) position;
- (void) performTap;

@end
