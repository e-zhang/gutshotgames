//
//  Player.h
//  CocosExperimental
//
//  Created by Eric Zhang on 11/12/12.
//
//

#ifndef __CocosExperimental__Player__
#define __CocosExperimental__Player__

#include <iostream>
#include "Box2d.h"
#include "cocos2d.h"

namespace GutShotGames {
namespace Characters {

    class Player
    {
    public:
        Player(b2World* world, CGSize winSize, float relativeSize);
        ~Player();
        
        // Accessors 
        CCSprite* GetSprite() { return _playerSprite; }
        b2Body* GetBody() { return _playerBody; }
        b2Fixture* GetFixture() { return _playerFixture; }
        b2Vec2 GetPosition() { return _playerBody->GetPosition(); }
        
        // Update Methods
        void UpdatePosition();
        void UpdateRotation();
        
        void HandleCollision(Player* otherPlayer);
        
    private:
        CCSprite* _playerSprite;
        b2Body* _playerBody;
        b2Fixture* _playerFixture;
    };
        
}
}

#endif /* defined(__CocosExperimental__Player__) */
