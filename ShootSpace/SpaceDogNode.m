//
//  SpaceDogNode.m
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import "SpaceDogNode.h"
#import "Utility.h"

@implementation SpaceDogNode


+ (instancetype) spaceDogOfType: (SpaceDogType) type {
    SpaceDogNode * spaceDog;
    NSArray *textures;
    
    if (type == SpaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[ [SKTexture textureWithImageNamed:@"spacedog_A_1"],
                      [SKTexture textureWithImageNamed:@"spacedog_A_2"],
                      [SKTexture textureWithImageNamed:@"spacedog_A_3"]];
    }else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[ [SKTexture textureWithImageNamed:@"spacedog_B_1"],
                      [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                      [SKTexture textureWithImageNamed:@"spacedog_B_3"],
                      [SKTexture textureWithImageNamed:@"spacedog_B_4"]];
    }
    
    float scale = [Utility randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;

    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    [spaceDog setupPhysicsBody];
    return spaceDog;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryProjectile | CollisionCategoryGround;
}

@end
