//
//  GameOverNode.h
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverNode : SKNode
+(instancetype) gameOverAtPosition: (CGPoint) position;

- (void) performAnimation;

@end
