//
//  HudNode.h
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKSpriteNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition: (CGPoint) position inFrame: (CGRect) frame;

- (void) addPoints: (NSInteger) points;
- (BOOL) loseLife;


@end
