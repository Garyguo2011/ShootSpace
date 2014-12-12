//
//  NinjaNode.m
//  ShootSpace
//
//  Created by Gary Guo-I on 12/9/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import "NinjaNode.h"

@interface NinjaNode ()
@property (nonatomic) SKAction *tapAction;
@end


@implementation NinjaNode

+ (instancetype) ninjaAtPosition: (CGPoint) position {
    NinjaNode *ninja = [self spriteNodeWithImageNamed:@"ninja_1"];
    ninja.anchorPoint = CGPointMake(0.5, 0);
    ninja.position = position;
    ninja.name = @"ninja";
    ninja.zPosition = 9;
    
    return ninja;
}

- (void) performTap{
    [self runAction: self.tapAction];
}

- (SKAction *) tapAction {
    if (_tapAction != nil) {
        return _tapAction;
    }
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"ninja_2"], [SKTexture textureWithImageNamed:@"ninja_1"]];
    _tapAction = [SKAction animateWithTextures:textures timePerFrame: 0.25 ];
    return _tapAction;
}



@end
