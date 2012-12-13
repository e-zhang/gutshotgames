//
//  PlayerContactListener.m
//  CocosExperimental
//
//  Created by Eric Zhang on 11/15/12.
//
//

#include "PlayerContactListener.h"
#include "GamePlayer.h"


namespace GutShotGames {
namespace Characters {
    
    float PlayerContactListener::COLLISION_THRESHOLD = 12.5;
    float PlayerContactListener::DIFF_SCALAR = 1.0;
    float PlayerContactListener::DIFF_RANGE = 5.0;
    
    void PlayerContactListener::BeginContact(b2Contact* contact)
    {
        // handle contacts
    }
    
    void PlayerContactListener::EndContact(b2Contact* contact)
    {
        GamePlayer *actorA, *actorB;
        
        actorA = (GamePlayer*)contact->GetFixtureA()->GetBody()->GetUserData();
        actorB = (GamePlayer*)contact->GetFixtureB()->GetBody()->GetUserData();
        
        if (actorA == nil || actorB == nil) return;
        
        [actorA BeginStun];
        [actorB BeginStun];
    }
  
    void PlayerContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
    {
        
    }
    
    void PlayerContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
    {
        GamePlayer *actorA, *actorB;
        
        actorA = (GamePlayer*)contact->GetFixtureA()->GetBody()->GetUserData();
        actorB = (GamePlayer*)contact->GetFixtureB()->GetBody()->GetUserData();
        
        // apparently the first index has useful information
        float collisionImpulse = impulse->normalImpulses[0];
        
        if (actorA == nil|| actorB == nil ||
            collisionImpulse < COLLISION_THRESHOLD) return;
        
        if ([actorA Body]->GetMass() > 0.0f &&
            [actorB Body]->GetMass() > 0.0f)
        {
            
            float energyA = GetEnergy([actorA Body]);
            float energyB = GetEnergy([actorB Body]);
            
            float energy = ((energyA + energyB)/2.0)*DIFF_SCALAR;
            float energyDiff = energyA - energyB;
            
            if (energyDiff > DIFF_RANGE)
            {
                [actorB SetStunFromEnergy:energy];
            }
            else if (energyDiff < -1.0*DIFF_RANGE)
            {
                [actorA SetStunFromEnergy:(energy)];
            }
            else
            {
                [actorA SetStunFromEnergy:energy];
                [actorB SetStunFromEnergy:energy];
            }
        }
        
        
    }
    
    float PlayerContactListener::GetEnergy(b2Body* body)
    {
        // (1/2)mv^2
        float linearKE = 0.5*body->GetMass()*body->GetLinearVelocity().LengthSquared();
        
        float angularKE = 0.5*body->GetInertia()*body->GetAngularVelocity()*body->GetAngularVelocity();
        
        return linearKE + angularKE;
    }
    
}
}
