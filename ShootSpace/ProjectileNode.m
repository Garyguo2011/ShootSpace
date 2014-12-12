//
//  ProjectileNode.m
//  ShootSpace
//
//  Created by Gary Guo-I on 12/10/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import "ProjectileNode.h"
#import "Utility.h"

@implementation ProjectileNode

+ (instancetype) projectileAtPosition: (CGPoint) position {
    ProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];
    [projectile setupPhysicsBody];
    
    return projectile;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
}

- (void) setupAnimation {
    NSArray * textures = @[ [SKTexture textureWithImageNamed:@"projectile_1"],
                            [SKTexture textureWithImageNamed:@"projectile_2"],
                            [SKTexture textureWithImageNamed:@"projectile_3"] ];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
}

- (void) moveTowardsPosition: (CGPoint) position {
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    float offscreenX;
    if (position.x <= self.position.x) {
        offscreenX = -10;
    }else{
        offscreenX = self.parent.frame.size.width + 10;
    }
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffScreen = CGPointMake(offscreenX, offscreenY);
    float distanceA = pointOffScreen.y - self.position.y;
    float distanceB = pointOffScreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB , 2));

    float time = distanceC / ProjectileSpeed;
    float waitToFade = time * 0.75;
    float fadeTime = time - waitToFade;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffScreen duration:time];
    [self runAction:moveProjectile];
    
    NSArray *sequence = @[ [SKAction waitForDuration:waitToFade],
                           [SKAction fadeOutWithDuration:fadeTime],
                           [SKAction removeFromParent]];
    [self runAction:[SKAction sequence:sequence]];
    
}

@end
