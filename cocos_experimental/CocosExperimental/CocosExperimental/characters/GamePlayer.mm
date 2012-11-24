//
//  player.cpp
//  CocosExperimental
//
//  Created by Eric Zhang on 11/12/12.
//
//

#include "Player.h"
#include "GameLayer.h"

#define DEFAULT_DENSITY 10.0f
#define DEFAULT_FRICTION 1.0f
#define DEFAULT_RESTITUTION 0.01f


namespace GutShotGames {
namespace Characters {
    
    Player::Player(b2World* world, CGSize winSize, float relativeSize)
    {
        _playerSprite = [CCSprite spriteWithFile:@"Icon-Small-50.png"
                                  rect:CGRectMake(0, 0, 52, 52)];
        _playerSprite.position = ccp(WORLD_TO_SCREEN(winSize.width/2*relativeSize),WORLD_TO_SCREEN(winSize.height/2*relativeSize) );
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.linearDamping = 1.0f;
        ballBodyDef.angularDamping = 0.01f;
        ballBodyDef.position.Set(WORLD_TO_SCREEN(winSize.width/2), WORLD_TO_SCREEN(winSize.height/2));
        ballBodyDef.userData = this;
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
    }
    
    Player::~Player()
    {
        delete _playerFixture;
        
        _playerFixture = NULL;
        _playerBody = NULL;
        _playerSprite = NULL;
        
    }
    
    
    void Player::UpdatePosition()
    {
        _playerSprite.position = ccp(_playerBody->GetPosition().x * PTM_RATIO,
                                     _playerBody->GetPosition().y * PTM_RATIO);
    }
    
    void Player::UpdateRotation()
    {
        _playerSprite.rotation =
            -1 * CC_RADIANS_TO_DEGREES(_playerBody->GetAngle());
    }
    
    void Player::HandleCollision(Player* player)
    {
        
    }
}
}