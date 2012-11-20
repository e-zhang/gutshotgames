//
//  PlayerContactListener.m
//  CocosExperimental
//
//  Created by Eric Zhang on 11/15/12.
//
//

#include "PlayerContactListener.h"

namespace GutShotGames {
namespace Characters {

    void PlayerContactListener::BeginContact(b2Contact* contact)
    {
        // handle contacts
    }
    
    void PlayerContactListener::EndContact(b2Contact* contact)
    {
        
    }
  
    void PlayerContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
    {
        
    }
    
    void PlayerContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
    {
        // handles forces of collision
    }
    
}
}
