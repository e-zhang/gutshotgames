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
#import "PhysicsSprite.h"

@interface GamePlayer : CCNode
{
    @private
    b2Body* _playerBody;
    b2Fixture* _playerFixture;
    
    BOOL _isStunned;
    u_int32_t _stunChance;
    NSTimer* _stunTimer;
    
    float _maxLinearVelocity;
    float _maxAngularVelocity;
    
    float _linearForce;
    float _torque;
    
}

@property(readonly, assign) b2Body* Body;
@property(readonly, assign) b2Fixture* Fixture;
@property(readonly) BOOL IsStunned;

-(id) initWithWorld:(b2World *)world WinSize:(CGSize)winSize RelativeSize:(float)relativeSize;

-(b2Vec2) GetPosition;

-(void) OnSpin:(NSTimer *)timer;
-(void) MoveToTouchLocation:(b2Vec2*)location TimeStep:(float)dt;

-(void) SetStunFromEnergy:(float)energy;
-(void) BeginStun;
-(void) OnStunTimeout:(NSTimer *)timer;

@end

/* original c++ interface */
//
//namespace GutShotGames {
//namespace Characters {
//
//    class Player
//    {
//    public:
//        Player(b2World* world, CGSize winSize, float relativeSize);
//        ~Player();
//        
//        // Accessors 
//        CCSprite* GetSprite() const { return _playerSprite; }
//        b2Body* GetBody() const { return _playerBody; }
//        b2Fixture* GetFixture() const { return _playerFixture; }
//        b2Vec2 GetPosition() const { return _playerBody->GetPosition(); }
//        bool IsStunned() const { return _isStunned };
//        
//        // Update Methods
//        void UpdatePosition();
//        void UpdateRotation();
//        
//        void HandleCollision(Player* otherPlayer);
//        void SetStun();
//        
//    private:
//        CCSprite* _playerSprite;
//        b2Body* _playerBody;
//        b2Fixture* _playerFixture;
//        
//        bool _isStunned;
//        int _stunChance;
//        
//        NSTimer* _stunTimer;
//        void OnStunTimer(NSTimer *);
//    };
//        
//}
//}


#endif /* defined(__CocosExperimental__Player__) */
