//
//  HelloWorldLayer.mm
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"

enum {
	kTagParentNode = 1,
};


#pragma mark - GameLayer

@interface GameLayer()
-(void) initPhysics;
-(void) createMenu;
-(void) createPlayers;
-(void) createGameLog;
-(void) onSubmitMove:(Move) move;
-(void) simulateRound;
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
	if( (self=[super init])) {
		
		// enable events
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		_isGameOver = NO;
        
		// init physics
		[self initPhysics];
        
        [self createPlayers];
		
		// create reset button
		[self createMenu];
        
		//Set up sprite
        [self createGameLog];
		
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    [_charactersMap release];
	
	[super dealloc];
}	

-(void) createPlayers
{
	CGSize size = [[CCDirector sharedDirector] winSize];
    _charactersMap = [[NSMutableDictionary alloc] init];
    
    Character* compChar = [[Character alloc] initWithId:@"ComputerPlayer"];
    [_charactersMap setObject:compChar forKey:compChar.Id];
    [compChar setDisplayLocation:ccp(size.width*0.5, 0.6*size.height)];
    
    _myCharacter = @"MyPlayer";
    Character* myChar = [[Character alloc] initWithId: _myCharacter];
    [_charactersMap setObject:myChar forKey:myChar.Id];
    [myChar setDisplayLocation:ccp(size.width*0.5, 0.5*size.height)];
    
    [self addChild:myChar.Display z:1];
    [self addChild:compChar.Display z:1];
}

-(void) createGameLog
{
	CGSize size = [[CCDirector sharedDirector] winSize];
    _gameLog = [[[UITextView alloc] initWithFrame:CGRectMake(0.32*size.width, 0.6*size.height, 400.0f, 200.0f)] autorelease];
    [_gameLog setBackgroundColor:[UIColor whiteColor]];
    _gameLog.editable = NO;
    _gameLog.text = @"Commencing game...";
    
    [[[CCDirector sharedDirector] view] addSubview: _gameLog];
}

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Restart" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
	}];
	
	
	CCMenu *menu = [CCMenu menuWithItems:reset, nil];
    
    for (int i = 0; i < MOVECOUNT; ++i)
    {
        NSString* move = MoveStrings[i];
        Move nextMove = {.TargetId = @"ComputerPlayer", .Type = (MoveType)i};
        CCMenuItemLabel* moveLabel = [CCMenuItemFont itemWithString:move block:^(id sender){
            [self onSubmitMove:nextMove];
        }];
        
        [menu addChild: moveLabel];
    }
    
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/8, 4*size.height/5)];
	
	[self addChild: menu z:-1];	
}

-(void) onSubmitMove:(Move)move
{
    Character* myChar = [_charactersMap valueForKey:_myCharacter];
    if(![myChar UpdateNextMove:move]) return;
    
    Character* compChar = [_charactersMap valueForKey:@"ComputerPlayer"];
    [compChar RandomizeNextMove:_myCharacter];
    
    [self simulateRound];
}

-(void) simulateRound
{
    if (_isGameOver) return;
    
    //simulate attacks
    
    for(Character* c in [_charactersMap allValues])
    { 
        switch(c.NextMove.Type)
        {
            case ATTACK:
            case SUPERATTACK:
                Character* target = [_charactersMap valueForKey:c.NextMove.TargetId];
                if ([target OnAttack:c.NextMove.Type])
                {
                    [c OnRebate];
                }
        }
    }
    
    //commit round updates
    NSMutableString* gameUpdates = [NSMutableString stringWithFormat:@"\n"];
    NSMutableArray* deadChars = [[[NSMutableArray alloc] init] autorelease];
    for(Character* c in [_charactersMap allValues])
    {
        [gameUpdates appendString:[c CommitUpdates]];
        if([c IsDead])
        {
            [deadChars  addObject:c];
        }
    }
    
    int charsLeft = [_charactersMap count] - [deadChars count];
    _isGameOver = charsLeft <= 1;
    if( charsLeft == 1)
    {
        [gameUpdates appendString:@"Game Over...\n"];
        [gameUpdates appendString:@"Winner is "];
        for(Character* c in [_charactersMap allValues])
        {
            if([deadChars containsObject:c]) continue;
            
            [gameUpdates appendString:c.Id];
            break;
        }
    }
    else if (charsLeft == 0)
    {
        [gameUpdates appendString:@"Game Over...\n"];
        [gameUpdates appendString:@"Draw between "];
        for(Character* c in deadChars)
        {
            [gameUpdates appendString:[NSString stringWithFormat:@"%@    ", c.Id]];
        }
    }
    else
    {
        for(Character* c in deadChars)
        {
            [gameUpdates appendString:[NSString stringWithFormat:@"%@ has been killed\n", c.Id]];
            [_charactersMap removeObjectForKey:c.Id];
        }
    }
    
    _gameLog.text = [_gameLog.text stringByAppendingString:gameUpdates];
    [_gameLog scrollRangeToVisible:[_gameLog selectedRange]];
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
