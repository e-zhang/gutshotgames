//
//  PlayerContactListener.h
//  CocosExperimental
//
//  Created by Eric Zhang on 11/15/12.
//
//

#ifndef PLAYER_CONTACT_LISTENER_H_
#define PLAYER_CONTACT_LISTENER_H_

#include "cocos2d.h"
#include "Box2D.h"

namespace GutShotGames {
namespace Characters {

    class PlayerContactListener : public b2ContactListener
    {
    public:
        
        void BeginContact(b2Contact* contact);
        void EndContact(b2Contact* contact);
        void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
        void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
        
    private:
        
        static float COLLISION_THRESHOLD;
        static float DIFF_SCALAR;
        static float DIFF_RANGE;
        
        float GetEnergy(b2Body* body);
        
    };
    
}
}

#endif