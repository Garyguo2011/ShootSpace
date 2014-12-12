//
//  GameTitleScene.m
//  ShootSpace
//
//  Created by Gary Guo-I on 12/9/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import "GameTitleScene.h"
#import "GamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface GameTitleScene ()
@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@end

@implementation GameTitleScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed: @"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];

        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
        
    }
    return self;
}


- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self runAction:self.pressStartSFX];
    [self.backgroundMusic stop];
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

//
//-(void)didMoveToView:(SKView *)view {
//    /* Setup your scene here */
//    
//    
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
//    SKSpriteNode *greenNode = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(100, 100)];
//    greenNode.position = CGPointMake(CGRectGetMidX(self.frame),
//                                     CGRectGetMidY(self.frame));
//    [self addChild:greenNode];
//    
//}

@end
