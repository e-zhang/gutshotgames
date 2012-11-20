//
//  GameLayer.mm
//  CocosExperimental
//
//  Created by Eric Zhang on 10/30/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"
#import "Box2D.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"
#import "CCTouchDispatcher.h"

using namespace GutShotGames;


enum {
	kTagParentNode = 1,
};


#pragma mark - GameLayer

@interface GameLayer()

@end

@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if (self = [super init])
    {
    }
    
    // ask director for the window size
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Create a world
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    _world = new b2World(gravity);
    
    // Create sprite and add it to the layer
    _myPlayer = new GutShotGames::Characters::Player(_world, winSize, 1.0);
    [self addChild: _myPlayer->GetSprite()];
    auto autoPlayer = new GutShotGames::Characters::Player(_world, winSize, 5.0);
    [self addChild: autoPlayer->GetSprite()];
    [autoPlayer->GetSprite() runAction:[CCRepeatForever actionWithAction:
                    [CCSequence actions:
                     [CCMoveTo actionWithDuration:1.0 position:ccp(300,100)],
                     [CCMoveTo actionWithDuration:1.0 position:ccp(200,200)],
                     [CCMoveTo actionWithDuration:1.0 position:ccp(100,100)],
                     nil]]];
    
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    b2EdgeShape groundEdge;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &groundEdge;
    groundEdge.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&boxShapeDef);
    groundEdge.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&boxShapeDef);
    groundEdge.Set(b2Vec2(0, winSize.height/PTM_RATIO),
                   b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&boxShapeDef);
    groundEdge.Set(b2Vec2(winSize.width/PTM_RATIO,
                          winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&boxShapeDef);
    
       
    self.isTouchEnabled = YES;
    
    [self schedule:@selector(tick:)];
    
    return self;
}

-(void) dealloc
{
	delete _world;
	_world = NULL;
    
    
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    delete _myPlayer;
    _myPlayer = NULL;
	
	[super dealloc];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    b2MouseJointDef md;
    md.bodyA = _groundBody;
    md.bodyB = _myPlayer->GetBody();
    md.collideConnected = true;
    md.target = _myPlayer->GetPosition();
    md.maxForce = 1000.0f * _myPlayer->GetBody()->GetMass();
    
    _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
    _mouseJoint->SetTarget(locationWorld);
    _myPlayer->GetBody()->SetAwake(true);
    
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

- (void)tick:(ccTime) dt {
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            Characters::Player *player = (Characters::Player*)b->     GetUserData();
            
            player->UpdatePosition();
            player->UpdateRotation();
            
        }
    }
    

}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	return YES;
}




@end