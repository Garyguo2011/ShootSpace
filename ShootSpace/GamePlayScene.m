//
//  GamePlayScene.m
//  ShootSpace
//
//  Created by Gary Guo-I on 12/9/14.
//  Copyright (c) 2014 XinranGuo-XuHe. All rights reserved.
//

#import "GamePlayScene.h"
#import "MachineNode.h"
#import "NinjaNode.h"
#import "ProjectileNode.h"
#import "SpaceDogNode.h"
#import "GroundNode.h"
#import "Utility.h"
#import <AVFoundation/AVFoundation.h>
#import "HudNode.h"
#import "GameOverNode.h"

@interface GamePlayScene()
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;

@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplayed;


@end

@implementation GamePlayScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.totalGameTime = 0;
        self.minSpeed = SpaceDogMinSpeed;
        self.addEnemyTimeInterval = 1.5;
        self.restart = NO;
        self.gameOver = NO;
        self.gameOverDisplayed = NO;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed: @"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        SKSpriteNode *machine = [MachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 25)];
        [self addChild:machine];
        
        NinjaNode *ninja = [NinjaNode ninjaAtPosition: CGPointMake(machine.position.x, machine.position.y)];
        [self addChild:ninja];
        
//        [self addSpaceDog];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        [self setupSounds];
        
        HudNode *hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
        [self addChild:hud];
        
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) setupSounds {
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 1;
    [self.gameOverMusic prepareToPlay];
}

//- (void) update:(NSTimeInterval)currentTime {
//    NSLog(@"%f", fmod(currentTime, 60));
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver){
        for (UITouch *touch in touches){
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardsPosition:position];
            
        }
    } else if (self.restart) {
        for (SKNode *node in [self children]){
            [node removeFromParent];
        }
        
        GamePlayScene *scene = [ GamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}


- (void) shootProjectileTowardsPosition: (CGPoint) position {
    NinjaNode *ninja = (NinjaNode*) [self childNodeWithName:@"ninja"];
    [ninja performTap];
    
    MachineNode  *machine = (MachineNode*) [self childNodeWithName:@"Machine"];
    
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height-15)];
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
    [self runAction:self.laserSFX];
}

- (void) performGameOver {
    GameOverNode *gameOver = [GameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    [self addChild:gameOver];
    [gameOver performAnimation];
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
}

- (void) addSpaceDog {
//    SpaceDogNode *spaceDogA = [SpaceDogNode spaceDogOfType:SpaceDogTypeA];
//    spaceDogA.position = CGPointMake(100, 300);
//    [self addChild:spaceDogA];
//    
//    SpaceDogNode *spaceDogB = [SpaceDogNode spaceDogOfType:SpaceDogTypeB];
//    spaceDogB.position = CGPointMake(200, 300);
//    [self addChild:spaceDogB];
    NSUInteger randomSpaceDog = [Utility randomWithMin:0 max:2];
    SpaceDogNode *spaceDog = [SpaceDogNode spaceDogOfType:randomSpaceDog];
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [Utility randomWithMin:10+spaceDog.size.width max: self.frame.size.width-spaceDog.size.width-10];
    
    float dy = [Utility randomWithMin:SpaceDogMinSpeed max:SpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
}

- (void) update:(NSTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval){
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    self.lastUpdateTimeInterval = currentTime;
    
    if (self.totalGameTime > 480) {
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = -160;
    }else if (self.totalGameTime > 240) {
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    }else if (self.totalGameTime > 120) {
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    }else if (self.totalGameTime > 30) {
        self.addEnemyTimeInterval = 1.00;
        self.minSpeed = -100;
    }
    
    if (self.gameOver && !self.gameOverDisplayed) {
        [self performGameOver];
    }
    
}

- (void) didBeginContact: (SKPhysicsContact*) contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (contact.bodyA.categoryBitMask == CollisionCategoryEnemy && contact.bodyB.categoryBitMask == CollisionCategoryProjectile ){
        SpaceDogNode *spaceDog = (SpaceDogNode *) firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *) secondBody.node;
        
        [self addPoints: PointsPerHit];
        
        [self runAction:self.explodeSFX];
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        
    } else if (firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryGround ) {
        
        SpaceDogNode *spaceDog = (SpaceDogNode *) firstBody.node;
        [self runAction:self.damageSFX];
        [spaceDog removeFromParent];
        
        [self loselife];
    }

    [self createDebrisAtPosition:contact.contactPoint];
}

- (void) addPoints: (NSInteger) points {
    HudNode *hud = (HudNode*) [self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

- (void) loselife {
    HudNode *hud = (HudNode*) [self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
    
}

- (void) createDebrisAtPosition: (CGPoint) position {
    NSInteger numberOfPieces = [Utility randomWithMin:5 max:20];
//    NSString *imageName;
    for (int i = 0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [Utility randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%d", (int)randomPiece];
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        [self addChild:debris];
        debris.position = position;
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = CollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryDebris;
        debris.name = @"Debris";
        
        debris.physicsBody.velocity = CGVectorMake([Utility randomWithMin:-150 max:150], [Utility randomWithMin:150 max:350]);
        
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
            [debris removeFromParent];
        }];
        
    }
    
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
}
@end
