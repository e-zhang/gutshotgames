//
//  GameLayer.h
//  CocosExperimental
//
//  Created by Eric Zhang on 10/30/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GamePlayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define WORLD_TO_SCREEN(x) x/PTM_RATIO


// GameLayer
@interface GameLayer : CCLayer
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* _world;					// strong ref
    GamePlayer* _myPlayer;
	GLESDebugDraw *m_debugDraw;		// strong ref
    b2MouseJoint* _mouseJoint;
    b2Body* _groundBody;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end
