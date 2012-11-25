//
//  CocosExperimental
//
//  Created by Eric Zhang on 11/12/12.
//
//

#import "GamePlayer.h"
#import "GameLayer.h"

#define DEFAULT_DENSITY 10.0f
#define DEFAULT_FRICTION 1.0f
#define DEFAULT_RESTITUTION 0.01f

enum
{
    SPRITE_TAG=1,
};


@implementation GamePlayer : CCNode

@synthesize Body = _playerBody;
@synthesize Fixture = _playerFixture;
@synthesize IsStunned = _isStunned;
    
-(id) initWithWorld:(b2World *)world WinSize:(CGSize) winSize RelativeSize:(float) relativeSize
{
    if (self = [super init])
    {
        CCSprite* playerSprite = [CCSprite spriteWithFile:@"Icon-Small-50.png"
                                           rect:CGRectMake(0, 0, 52, 52)];
        
        [playerSprite setPosition:ccp(WORLD_TO_SCREEN(winSize.width/(2*relativeSize)),
                                      WORLD_TO_SCREEN(winSize.height/(2*relativeSize)))];
        [self addChild:playerSprite z:0 tag:SPRITE_TAG];
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.linearDamping = 1.0f;
        ballBodyDef.angularDamping = 0.01f;
        ballBodyDef.position.Set(WORLD_TO_SCREEN(winSize.width/(2*relativeSize)),
                                 WORLD_TO_SCREEN(winSize.height/(2*relativeSize)));
        ballBodyDef.userData = self;
        
        _playerBody = world->CreateBody(&ballBodyDef);
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        
        //default properties
        ballShapeDef.density = DEFAULT_DENSITY*relativeSize;
        ballShapeDef.friction = 1.0f*relativeSize;
        ballShapeDef.restitution = 0.1f*relativeSize;
        _playerFixture = _playerBody->CreateFixture(&ballShapeDef);
        
        _isStunned = false;
        _stunChance = 250;
        _spinTorque = 10.0f;
        
    }
    
    return self;
}


-(void) dealloc
{
    [_stunTimer release];
    _stunTimer = nil;
    
    [super dealloc];
}


-(b2Vec2) GetPosition
{
    return _playerBody->GetPosition();
}


-(void) UpdatePosition
{
    [[self getChildByTag:SPRITE_TAG]
        setPosition:ccp(_playerBody->GetPosition().x * PTM_RATIO,
                        _playerBody->GetPosition().y * PTM_RATIO)];
}


-(void) UpdateRotation
{
    if (!_isStunned)
    {
        _playerBody->ApplyTorque(_spinTorque);
        [[self getChildByTag:SPRITE_TAG]
               setRotation:-1.0*CC_RADIANS_TO_DEGREES(_playerBody->GetAngle())];
    }

}


-(void) SetStunFromEnergy:(float)energy
{
    if (_isStunned || _stunTimer != nil) return;
    
    u_int32_t isStun = arc4random() % (u_int32_t)energy;
    if (isStun > _stunChance)
    {
        _isStunned =  YES;
    }
    else
    {
        _isStunned = NO;
    }
}

-(void) BeginStun
{
    if(_isStunned)
    {
        _stunTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                              target:self
                              selector:@selector(OnStunTimeout:)
                              userInfo:nil
                              repeats:NO];
    }
}


-(void) OnStunTimeout:(NSTimer *)timer
{
    _isStunned = NO;
    _stunTimer = nil;
}

@end

/* original c++ impl */
//
//namespace GutShotGames {
//namespace Characters {
//
//    Player::Player(b2World* world, CGSize winSize, float relativeSize)
//    {
//        _playerSprite = [CCSprite spriteWithFile:@"Icon-Small-50.png"
//                                  rect:CGRectMake(0, 0, 52, 52)];
//        _playerSprite.position = ccp(WORLD_TO_SCREEN(winSize.width/2*relativeSize),WORLD_TO_SCREEN(winSize.height/2*relativeSize) );
//        
//        // Create ball body and shape
//        b2BodyDef ballBodyDef;
//        ballBodyDef.type = b2_dynamicBody;
//        ballBodyDef.linearDamping = 1.0f;
//        ballBodyDef.angularDamping = 0.01f;
//        ballBodyDef.position.Set(WORLD_TO_SCREEN(winSize.width/2), WORLD_TO_SCREEN(winSize.height/2));
//        ballBodyDef.userData = this;
//        _playerBody = world->CreateBody(&ballBodyDef);
//        
//        b2CircleShape circle;
//        circle.m_radius = 26.0/PTM_RATIO;
//        
//        b2FixtureDef ballShapeDef;
//        ballShapeDef.shape = &circle;
//        
//        //default properties
//        ballShapeDef.density = DEFAULT_DENSITY*relativeSize;
//        ballShapeDef.friction = 1.0f*relativeSize;
//        ballShapeDef.restitution = 0.1f*relativeSize;
//        
//        _playerFixture = _playerBody->CreateFixture(&ballShapeDef);
//        
//        _isStunned = false;
//        _stunChance = 10;
//    }
//    
//    Player::~Player()
//    {
//        delete _playerFixture;
//        
//        _playerFixture = NULL;
//        _playerBody = NULL;
//        _playerSprite = NULL;
//        
//    }
//    
//    
//    void Player::UpdatePosition()
//    {
//        _playerSprite.position = ccp(_playerBody->GetPosition().x * PTM_RATIO,
//                                     _playerBody->GetPosition().y * PTM_RATIO);
//    }
//    
//    void Player::UpdateRotation()
//    {
//        _playerSprite.rotation =
//            -1 * CC_RADIANS_TO_DEGREES(_playerBody->GetAngle());
//    }
//    
//    void Player::HandleCollision(Player* player)
//    {
//        
//    }
//    
//    
//    void Player::SetStun()
//    {
//        u_int32_t isStun = arc4random() % _stunChance;
//        if (isStun == 1)
//        {
//            if (!_isStunned && _stunTimer==NULL)
//            {
//                _isStunned = true;
//                _stunTimer = [NSTimer scheduledTimerWithInterval: 1.0
//                                       target:this
//                                       selector:@selector(OnStunTimer))
//                                       userInfo:nil repeats: NO];
//            }
//        }
//    }
//
//
//
//                              
//
//}
//}