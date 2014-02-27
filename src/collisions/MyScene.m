//
//  MyScene.m
//  collisions
//
//  Created by Colin Milhench on 27/02/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import "MyScene.h"
#import "SKNode+Debug.h"

typedef enum : uint8_t {
    ColliderTypeWall            = 0x1 << 0,
    ColliderTypePlayer          = 0x1 << 1,
    ColliderTypeCamera          = 0x1 << 2,
    ColliderTypeObsticle        = 0x1 << 3
} ColliderType;

#define Peridot [SKColor colorWithRed:0xE8/255.0 green:0xDD/255.0 blue:0x00/255.0 alpha:1.0]

@implementation MyScene

#pragma mark -
#pragma mark Initialization methods
#pragma mark -

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        NSLog(@"testing....");
        
        SKNode *world = [SKNode node];
        // Give ouselves a cartesian grid system
        world.position = CGPointMake(self.size.width/2, self.size.height/2);
        world.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:
                             CGRectMake(size.width/-2, size.height/-2, size.width, size.height)];
        world.physicsBody.dynamic = NO; // unaffected by other physics bodies
        world.physicsBody.categoryBitMask = ColliderTypeWall;
        [world attachDebugRectWithSize:self.frame.size];
        [self addChild:world];
        
        SKNode *node = [self createObjectWithSize:CGSizeMake(20, 20) AndPosition:CGPointMake(0, 200)];
        node.physicsBody.dynamic = YES;
        node.physicsBody.affectedByGravity = YES;
        node.physicsBody.categoryBitMask = ColliderTypePlayer;
        node.physicsBody.collisionBitMask = ColliderTypeObsticle | ColliderTypeWall;
        node.physicsBody.contactTestBitMask = ColliderTypeObsticle | ColliderTypeWall;  // get a callback
        [world addChild:node];
        
        node = [self createObjectWithSize:CGSizeMake(20, 20) AndPosition:CGPointMake(15, -200)];
        node.physicsBody.dynamic = NO; // unaffected by other physics bodies
        node.physicsBody.affectedByGravity = NO;
        node.physicsBody.categoryBitMask = ColliderTypeObsticle;
        [world addChild:node];
        
        self.physicsWorld.contactDelegate = self; // Where are we handeling physics events?
        //self.physicsWorld.gravity = CGVectorMake(-1, -1);
    }
    return self;
}

#pragma mark -
#pragma mark Touch methods
#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}


#pragma mark -
#pragma mark Game loop
#pragma mark -

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark -
#pragma mark Collision methods
#pragma mark -

-(void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"BOOM!!! %d, %d", contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask);
}

#pragma mark -
#pragma mark -

- (SKShapeNode *)createObjectWithSize:(CGSize)size AndPosition:(CGPoint)position {
    CGRect rect = CGRectMake(size.width/-2, size.height/-2, size.width, size.height);
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    SKShapeNode *node = [SKShapeNode node];
    node.path = path;
    node.lineWidth = 0;
    node.fillColor = Peridot;
    node.position = position;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    [node attachDebugRectWithSize:size];
    CGPathRelease(path);
    return node;
}

@end
